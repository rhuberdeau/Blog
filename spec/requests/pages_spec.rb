
# Full-stack checks of every page a reader or the admin reaches. These render
# layouts, partials and assets, so they catch the breakage a Rails upgrade
# causes far more reliably than the controller specs do.
describe "Pages", type: :request do
  let!(:admin)   { create(:user) }
  let!(:article) { create(:article, user: admin, body: "Hello **world**\n\n```ruby\nputs 1\n```", tag_names: "ruby, docker") }
  let!(:draft)   { create(:article, user: admin, published: false, title: "Secret draft") }

  it "lists published articles on the home page" do
    get root_path
    expect(response.status).to eq(200)
    expect(response.body).to include(article.title)
    expect(response.body).not_to include(draft.title)
  end

  it "renders an article's Markdown and highlights its code" do
    get article_path(article)
    expect(response.status).to eq(200)
    expect(response.body).to include("<strong>world</strong>")
    expect(response.body).to match(%r{<pre[^>]*style="[^"]*background-color})
  end

  it "drops raw HTML from article bodies" do
    article.update!(body: "Hi <script>alert(1)</script> <img src=x onerror=alert(1)>")
    get article_path(article)
    expect(response.body).not_to include("<script>alert")
    expect(response.body).not_to include("onerror")
  end

  it "shows the articles carrying a tag" do
    get tag_path(Tag.find_by!(name: "docker"))
    expect(response.status).to eq(200)
    expect(response.body).to include(article.title)
  end

  it "renders the about page, with the contact address when one is set" do
    allow(Rails.configuration.x).to receive(:contact_email).and_return("me@example.com")
    get about_path
    expect(response.status).to eq(200)
    expect(response.body).to include("mailto:me@example.com")
  end


  it "lists published articles in the sitemap" do
    get sitemap_path
    expect(response.status).to eq(200)
    expect(response.content_type.to_s).to include("xml")
    expect(response.body).to include(article_url(article))
    expect(response.body).not_to include(article_url(draft))
  end

  it "shows drafts in the admin panel and publishes them" do
    sign_in_as(admin)
    get admin_path
    expect(response.status).to eq(200)
    expect(response.body).to include(draft.title)

    put articles_publish_path(draft)
    expect(response).to redirect_to(admin_path)
    expect(draft.reload.published).to eq(true)
  end

  it "keeps the admin panel from visitors" do
    get admin_path
    expect(response).to redirect_to(new_session_path)
  end
end
