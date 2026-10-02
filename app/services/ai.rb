# The AI writing assistant. Everything that talks to Claude goes through
# Ai::Client; each feature is an Ai::Tasks::* class (prompt, JSON schema,
# tools, and a canned result for tests). Suggestions are only ever shown;
# the author applies them by hand.
module Ai
  MODEL = "claude-opus-5".freeze

  # US dollars per million tokens, and per web search, for cost tracking.
  # Update when the model or Anthropic's prices change.
  PRICES = {
    "claude-opus-5" => { input: 5.00, output: 25.00 }
  }.freeze
  WEB_SEARCH_USD = 0.01

  class NotConfigured < StandardError; end
  class BudgetExceeded < StandardError; end
  class Failed < StandardError; end

  def self.configured?
    Client.fake? || ENV["ANTHROPIC_API_KEY"].present?
  end

  def self.cost_usd(model:, input_tokens:, output_tokens:, web_searches:)
    price = PRICES.fetch(model.to_s) { PRICES.fetch(MODEL) }
    (input_tokens * price[:input] + output_tokens * price[:output]) / 1_000_000.0 +
      web_searches * WEB_SEARCH_USD
  end
end
