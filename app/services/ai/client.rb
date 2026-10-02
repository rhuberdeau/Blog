require "anthropic"

module Ai
  # The only code that calls Anthropic. Runs one task (an Ai::Tasks::* class)
  # and returns its parsed JSON result with token usage.
  #
  # - Structured outputs: the task's JSON schema constrains the reply, so the
  #   result is parsed, never scraped from prose.
  # - Refusal fallbacks are on (server-side, "default" routing).
  # - Server tools (web search/fetch) can pause a long turn; the client
  #   continues it a few times before giving up.
  # - Tests call Ai::Client.fake!, which returns each task's canned result;
  #   a real client refuses to run in the test environment.
  class Client
    Result = Data.define(:data, :model, :input_tokens, :output_tokens, :web_searches)

    MAX_CONTINUATIONS = 4
    BETAS = [ "server-side-fallback-2026-07-01" ].freeze

    class << self
      def fake!
        @fake = true
      end

      def fake?
        @fake == true
      end

      def call(task, input)
        fake? ? fake_result(task, input) : new.call(task, input)
      end

      private
        def fake_result(task, input)
          Result.new(data: task.fake_result(input), model: MODEL, input_tokens: 1_000, output_tokens: 500,
                     web_searches: task.tools.any? ? 1 : 0)
        end
    end

    def initialize
      raise "Ai::Client must not call Anthropic from tests; use Ai::Client.fake!" if Rails.env.test?
      raise NotConfigured, "ANTHROPIC_API_KEY is not set." if ENV["ANTHROPIC_API_KEY"].blank?

      @client = Anthropic::Client.new(max_retries: 3, timeout: 300)
    end

    def call(task, input)
      prompt = { role: :user, content: task.user_prompt(input) }
      messages = [ prompt ]
      paused_content = []
      usage = Hash.new(0)
      message = nil

      (MAX_CONTINUATIONS + 1).times do
        message = request(task, messages)
        add_usage(usage, message.usage)
        break unless message.stop_reason == :pause_turn

        # A server tool paused the turn: send everything Claude produced so
        # far back, unchanged, so it carries on where it stopped.
        paused_content += message.content.map(&:to_h)
        messages = [ prompt, { role: :assistant, content: paused_content } ]
      end

      check_stop!(message)
      Result.new(data: parse(message), model: message.model.to_s, input_tokens: usage[:input],
                 output_tokens: usage[:output], web_searches: usage[:searches])
    end

    private
      def request(task, messages)
        params = {
          model: MODEL.to_sym,
          max_tokens: task.max_tokens,
          thinking: { type: :adaptive },
          system_: task.system_prompt,
          messages: messages,
          output_config: { format_: { type: :json_schema, schema: task.schema } },
          betas: BETAS,
          fallbacks: :default
        }
        params[:tools] = task.tools if task.tools.any?
        # Long requests stream so the HTTP connection doesn't time out.
        @client.beta.messages.stream(**params).accumulated_message
      end

      # Cached input is cheaper than full price; counting it at full price
      # keeps the recorded cost (and the budget) on the safe side.
      def add_usage(usage, reported)
        usage[:input] += reported.input_tokens.to_i + reported.cache_read_input_tokens.to_i +
                         reported.cache_creation_input_tokens.to_i
        usage[:output] += reported.output_tokens.to_i
        usage[:searches] += reported.server_tool_use&.web_search_requests.to_i
      end

      def check_stop!(message)
        case message.stop_reason
        when :refusal
          raise Failed, "Claude declined this request#{" (#{message.stop_details.category})" if message.stop_details&.category}."
        when :max_tokens
          raise Failed, "The response was cut off (too long). Try a shorter input."
        when :pause_turn
          raise Failed, "The research took too many steps. Try a narrower topic."
        end
      end

      # With structured outputs the final text block is the JSON answer.
      def parse(message)
        text = message.content.select { |block| block.type == :text }.last&.text
        raise Failed, "Claude returned no answer." if text.blank?

        JSON.parse(text)
      rescue JSON::ParserError
        raise Failed, "Claude's answer wasn't valid JSON."
      end
  end
end
