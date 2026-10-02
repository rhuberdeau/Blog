# The AI writing assistant: research and outlines on /admin/ai, review and
# metadata suggestions inside the article editor. Requests run in the
# background (AiRequestJob); pages poll #show until they're done. Nothing
# here changes an article except #draft, which the author clicks.
class AiRequestsController < ApplicationController
  before_action :set_ai_request, only: %i[show draft]

  # /admin/ai: research and outline forms, history and this month's spend.
  def index
    @ai_requests = AiRequest.recent.limit(50)
    @research_notes = AiRequest.where(kind: "research", status: "done").recent.limit(20)
  end

  def create
    raise Ai::NotConfigured, "AI is not configured: set ANTHROPIC_API_KEY." unless Ai.configured?
    Ai::Budget.check!

    @ai_request = AiRequest.create!(kind: params.require(:kind), article_id: params[:article_id].presence,
                                    input: input_for(params[:kind]))
    AiRequestJob.perform_later(@ai_request.id)

    if editor_panel?
      render partial: "ai_requests/ai_request", locals: { ai_request: @ai_request, context: "editor" }
    else
      redirect_to @ai_request
    end
  rescue Ai::NotConfigured, Ai::BudgetExceeded, ActiveRecord::RecordInvalid, ActionController::ParameterMissing => e
    if editor_panel?
      render partial: "ai_requests/error", locals: { message: e.message }, status: :unprocessable_content
    else
      redirect_to admin_ai_path, alert: e.message
    end
  end

  # Polled by ai_request_controller.js (?context=...) for the panel alone;
  # a normal visit shows the full page.
  def show
    if params[:context].present?
      render partial: "ai_requests/ai_request", locals: { ai_request: @ai_request, context: params[:context] }
    end
  end

  # Turns a finished outline into a new draft article and opens the editor.
  def draft
    unless @ai_request.kind == "outline" && @ai_request.done?
      return redirect_to @ai_request, alert: "Only a finished outline can become a draft."
    end

    article = Ai::OutlineDraft.new(@ai_request, author: Current.user).create!
    redirect_to edit_article_path(article), notice: "Draft created from the outline."
  end

  private
    def set_ai_request
      @ai_request = AiRequest.find(params[:id])
    end

    def editor_panel?
      params[:context] == "editor"
    end

    def input_for(kind)
      case kind
      when "review", "metadata"
        fields = params.require(:article).permit(:title, :summary, :body)
        input = fields.to_h
        input["existing_tags"] = Tag.order(:name).pluck(:name) if kind == "metadata"
        input
      when "research"
        { "topic" => params.require(:topic), "notes" => params[:notes].to_s }
      when "outline"
        input = { "topic" => params.require(:topic), "notes" => params[:notes].to_s }
        if (research = AiRequest.find_by(id: params[:research_id], kind: "research", status: "done"))
          input["research_id"] = research.id
          input["research"] = research.result.slice("summary", "key_points", "sources")
        end
        input
      else
        raise ActionController::ParameterMissing, :kind
      end
    end
end
