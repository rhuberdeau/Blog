describe "Atom feed", type: :request do
  let(:author) { create(:user) }

  it "lists published articles newest first, with their rendered bodies, and no drafts" do
    older = create(:article, user: author, title: "Older post", published_at: 2.days.ago)
    newer = create(:article, user: author, title: "Newer post", published_at: 1.day.ago, body: "Some **bold** text")
    create(:article, user: author, title: "Secret draft", published: false)

    get feed_path
    expect(response).to have_http_status(:ok)
    expect(response.media_type).to eq("application/atom+xml")

    feed = Nokogiri::XML(response.body)
    feed.remove_namespaces!
    expect(feed.xpath("//entry/title").map(&:text)).to eq([ newer.title, older.title ])
    expect(feed.at_xpath("//entry/content").text).to include("<strong>bold</strong>")
    expect(response.body).not_to include("Secret draft")
  end

  it "is advertised from every page" do
    get root_path
    expect(response.body).to include(%(type="application/atom+xml"))
  end
end
