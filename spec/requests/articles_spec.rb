# Writing articles is for the signed-in author only; reading is public.
describe "Articles", type: :request do
  let(:author) { create(:user) }
  let!(:article) { create(:article, user: author) }
  let(:params) { { article: { title: "A brand new article", summary: "Summary", body: "Body", published: "0" } } }

  it "lists only published articles" do
    draft = create(:article, user: author, published: false)
    get articles_path
    expect(response.body).to include(article.title)
    expect(response.body).not_to include(draft.title)
  end

  it "shows an article to anyone" do
    get article_path(article)
    expect(response).to have_http_status(:ok)
  end

  context "when signed out" do
    it "sends every writing action to the sign-in page" do
      get new_article_path
      expect(response).to redirect_to(new_session_path)
      get edit_article_path(article)
      expect(response).to redirect_to(new_session_path)

      expect { post articles_path, params: params }.not_to change(Article, :count)
      expect { patch article_path(article), params: { article: { body: "changed" } } }.not_to change { article.reload.body }
      expect { delete article_path(article) }.not_to change(Article, :count)
    end
  end

  context "when signed in" do
    before { sign_in_as(author) }

    it "renders the new and edit forms" do
      get new_article_path
      expect(response).to have_http_status(:ok)
      get edit_article_path(article)
      expect(response).to have_http_status(:ok)
    end

    it "creates an unpublished article owned by the author" do
      expect { post articles_path, params: params }.to change(Article, :count).by(1)
      created = Article.last
      expect(response).to redirect_to(created)
      expect(created.user).to eq(author)
      expect(created.published).to eq(false)
    end

    it "re-renders the form with 422 when invalid" do
      post articles_path, params: { article: { title: "" } }
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "updates an article" do
      patch article_path(article), params: { article: { body: "New body" } }
      expect(response).to redirect_to(article)
      expect(article.reload.body).to eq("New body")
    end

    it "deletes an article" do
      expect { delete article_path(article) }.to change(Article, :count).by(-1)
      expect(response).to redirect_to(articles_url)
    end
  end
end
