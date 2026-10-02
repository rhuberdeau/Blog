describe "AI assistant", type: :request do
  include ActiveJob::TestHelper

  let(:author) { create(:user) }

  it "is only for the signed-in author" do
    get admin_ai_path
    expect(response).to redirect_to(new_session_path)
    post ai_requests_path, params: { kind: "research", topic: "x" }
    expect(response).to redirect_to(new_session_path)
    expect(AiRequest.count).to eq(0)
  end

  context "when signed in" do
    before { sign_in_as(author) }

    it "queues research and shows it working, then the result" do
      expect { post ai_requests_path, params: { kind: "research", topic: "SQLite in production" } }
        .to have_enqueued_job(AiRequestJob)
      request = AiRequest.last
      expect(response).to redirect_to(ai_request_path(request))

      get ai_request_path(request)
      expect(response.body).to include("Working on it", "searching the web")

      perform_enqueued_jobs
      get ai_request_path(request, context: "page")
      expect(response.body).to include("Notes about SQLite in production.", "https://example.com/source")
      expect(response.body).not_to include("<html")
    end

    it "reviews the draft as typed in the editor and returns the panel" do
      article = create(:article, user: author, body: "Saved body")
      post ai_requests_path(context: "editor"),
           params: { kind: "review", article_id: article.id, article: { title: "T", summary: "S", body: "Unsaved words here" } }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(%(data-controller="ai-request"))
      request = AiRequest.last
      expect(request.article).to eq(article)
      expect(request.input["body"]).to eq("Unsaved words here")
    end

    it "builds an outline from saved research and turns it into a draft with the sources" do
      research = AiRequest.create!(kind: "research", status: "done", input: { "topic" => "SQLite" },
                                   result: { "summary" => "S", "key_points" => [ "K" ], "angles" => [],
                                             "sources" => [ { "title" => "Docs", "url" => "https://sqlite.org", "supports" => "K" } ] })
      post ai_requests_path, params: { kind: "outline", topic: "SQLite for blogs", research_id: research.id }
      outline = AiRequest.last
      expect(outline.input["research"]["key_points"]).to eq([ "K" ])
      perform_enqueued_jobs

      expect { post draft_ai_request_path(outline) }.to change(Article, :count).by(1)
      draft = Article.last
      expect(response).to redirect_to(edit_article_path(draft))
      expect(draft).not_to be_published
      expect(draft.body).to include("## Sources", "[Docs](https://sqlite.org)")
    end

    it "refuses new requests over the monthly budget" do
      AiRequest.create!(kind: "review", status: "done", cost_usd: 50)

      post ai_requests_path(context: "editor"), params: { kind: "review", article: { body: "x" } }
      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("budget")

      post ai_requests_path, params: { kind: "research", topic: "x" }
      expect(response).to redirect_to(admin_ai_path)
      expect(flash[:alert]).to include("budget")
      expect(AiRequest.count).to eq(1)
    end

    it "shows spend and history on the AI page" do
      AiRequest.create!(kind: "research", status: "done", input: { "topic" => "Kamal" }, cost_usd: 0.42,
                        result: { "summary" => "", "key_points" => [], "angles" => [], "sources" => [] })
      get admin_ai_path
      expect(response.body).to include("AI this month: $0.42", "Kamal")
    end
  end
end
