
# Full-stack checks of every page a reader or the admin reaches. These render
# layouts, partials and assets, so they catch the breakage a Rails upgrade
# causes far more reliably than the controller specs do.
describe "Pages", type: :request do
  let!(:admin)   { create(:user, admin: true) }
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
    expect(response.body).to include("CodeRay")
  end

  it "shows the articles carrying a tag" do
    get tag_path(Tag.find_by!(name: "docker"))
    expect(response.status).to eq(200)
    expect(response.body).to include(article.title)
  end

  it "renders the about page" do
    get about_path
    expect(response.status).to eq(200)
  end

  it "accepts a message from the contact form" do
    get new_contact_path
    expect(response.status).to eq(200)

    expect {
      post contacts_path, params: { contact: { name: "Ann", email_address: "ann@example.com", message: "Hi" } }
    }.to change(Contact, :count).by(1)
    expect(response).to redirect_to(root_url)
  end

  it "lists published articles in the sitemap" do
    get sitemap_path
    expect(response.status).to eq(200)
    expect(response.content_type.to_s).to include("xml")
    expect(response.body).to include(article_url(article))
    expect(response.body).not_to include(article_url(draft))
  end

  it "shows drafts in the admin panel and publishes them" do
    login_as(admin, scope: :user)
    get admin_path
    expect(response.status).to eq(200)
    expect(response.body).to include(draft.title)

    put articles_publish_path(draft)
    expect(response).to redirect_to(admin_path)
    expect(draft.reload.published).to eq(true)
  end

  it "keeps the admin panel from visitors" do
    get admin_path
    expect(response).to redirect_to(new_user_session_path)
  end
end
