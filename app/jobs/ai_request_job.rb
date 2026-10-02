# Runs one AI assistant request in the background (Solid Queue, inside Puma)
# and records the outcome on the AiRequest, which the page polls.
class AiRequestJob < ActiveJob::Base
  queue_as :default

  # Anthropic::Client already retries rate limits, overload and network
  # errors with backoff; anything still failing is reported on the request.
  discard_on ActiveRecord::RecordNotFound

  def perform(ai_request_id)
    request = AiRequest.find(ai_request_id)
    return if request.finished?

    request.update!(status: "running")
    result = Ai::Client.call(request.task, request.input)
    request.update!(
      status: "done",
      result: result.data,
      model: result.model,
      input_tokens: result.input_tokens,
      output_tokens: result.output_tokens,
      web_searches: result.web_searches,
      cost_usd: Ai.cost_usd(model: result.model, input_tokens: result.input_tokens,
                            output_tokens: result.output_tokens, web_searches: result.web_searches)
    )
  rescue Ai::Failed, Ai::NotConfigured => e
    request&.update!(status: "failed", error: e.message)
  rescue Anthropic::Errors::Error => e
    request&.update!(status: "failed", error: "Anthropic API error: #{e.message.to_s.truncate(300)}")
  end
end
