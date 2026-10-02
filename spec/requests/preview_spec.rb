# The editor's live preview: unsaved form values rendered with the article
# page's own partial, for the signed-in author only.
describe "Article preview", type: :request do
  let(:author) { create(:user) }
  let(:fields) { { title: "Draft <b>title</b>", summary: "A summary", body: "Some **bold**\n\n```ruby\nputs 1\n```\n\n<script>alert(1)</script>", tag_names: "ruby, new-tag" } }

  it "is only for the signed-in author" do
    post preview_articles_path, params: { article: fields }
    expect(response).to redirect_to(new_session_path)
  end

  context "when signed in" do
    before { sign_in_as(author) }

    it "renders the unsaved article like the article page, without the layout" do
      expect { post preview_articles_path, params: { article: fields } }.not_to change(Article, :count)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("<strong>bold</strong>", %(<pre class="syntax-highlighting">), "Draft", "1 min read", "ruby, new-tag")
      expect(response.body).to include("Draft &lt;b&gt;title&lt;/b&gt;")
      expect(response.body).not_to include("<script>")
      expect(response.body).not_to include("<html", "site-header")
      expect(Tag.find_by(name: "new-tag")).to be_nil
    end

    it "keeps an existing article's publish date and leaves it unchanged" do
      article = create(:article, user: author, published_at: Time.zone.parse("2026-03-04"), body: "Old body")

      post preview_articles_path(id: article.id), params: { article: { title: article.title, summary: "s", body: "New body", published: "1" } }

      expect(response.body).to include("New body", "Mar 4, 2026")
      expect(article.reload.body).to eq("Old body")
    end
  end
end
