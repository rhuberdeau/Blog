# The article editor in a real browser: live preview, word count, Markdown
# help, Ctrl+S, the unsaved-changes guard, phone tabs and the draft notice.
RSpec.describe "Article editor", type: :system do
  # The test environment turns CSRF protection off; the preview's fetch must
  # work with it on (per-form tokens once broke it), so run these as production does.
  around do |example|
    ActionController::Base.allow_forgery_protection = true
    example.run
  ensure
    ActionController::Base.allow_forgery_protection = false
  end

  let!(:author) { create(:user, password: "secret12345") }
  let!(:article) { create(:article, user: author, published: false, title: "Work in progress", body: "Start") }

  before do
    visit admin_path
    fill_in "Email", with: author.email_address
    fill_in "Password", with: "secret12345"
    click_button "Sign in"
    expect(page).to have_content("Unpublished Articles")
  end

  it "previews Markdown as you type and counts words" do
    visit edit_article_path(article)
    within(".editor-preview") { expect(page).to have_css("h1", text: "Work in progress") }

    fill_in "Body", with: "Some **bold** words\n\n```ruby\nputs 1\n```"
    within(".editor-preview") do
      expect(page).to have_css("strong", text: "bold")
      expect(page).to have_css("pre.syntax-highlighting")
    end
    # Counted on the raw Markdown, fences included, like Article#word_count.
    expect(page).to have_content("7 words · 1 min read")
  end

  it "explains the supported Markdown with rendered examples" do
    visit new_article_path
    find("summary", text: "Markdown help").click
    within(".markdown-help") do
      expect(page).to have_css("td.prose table th", text: "Gem")
      expect(page).to have_css("td.prose del", text: "struck")
    end
  end

  it "saves with Ctrl+S" do
    visit edit_article_path(article)
    fill_in "Summary", with: "Saved from the keyboard"
    find_field("Summary").send_keys([ :control, "s" ])
    expect(page).to have_content("Article was successfully updated.")
    expect(article.reload.summary).to eq("Saved from the keyboard")
  end

  it "asks before leaving with unsaved changes" do
    visit edit_article_path(article)
    fill_in "Title", with: "Changed title"

    dismiss_confirm("Discard unsaved changes?") { click_link "Home" }
    expect(page).to have_current_path(edit_article_path(article))

    accept_confirm("Discard unsaved changes?") { click_link "Home" }
    expect(page).to have_current_path(root_path)
    expect(article.reload.title).to eq("Work in progress")
  end

  it "doesn't ask when nothing changed" do
    visit edit_article_path(article)
    click_link "Home"
    expect(page).to have_current_path(root_path)
  end

  it "switches between Write and Preview on a phone" do
    page.driver.browser.manage.window.resize_to(390, 844)
    visit edit_article_path(article)
    expect(page).to have_field("Body")
    expect(page).to have_no_css(".editor-preview", visible: true)

    click_button "Preview"
    expect(page).to have_css(".editor-preview h1", text: "Work in progress")
    expect(page).to have_no_field("Body")

    click_button "Write"
    expect(page).to have_field("Body")
  ensure
    page.driver.browser.manage.window.resize_to(1400, 1000)
  end

  it "marks a draft's page and lets you publish from it" do
    visit article_path(article)
    within(".draft-notice") do
      expect(page).to have_content("only you can see this page")
      click_button "Publish"
    end
    expect(page).to have_content("'Work in progress' was successfully published.")
    expect(article.reload).to be_published
  end
end
