# The AI assistant in a real browser, with the fake Claude client. Jobs are
# queued by the app and performed here, so the pages' polling is exercised.
RSpec.describe "AI assistant", type: :system do
  include ActiveJob::TestHelper

  around do |example|
    ActionController::Base.allow_forgery_protection = true
    example.run
  ensure
    ActionController::Base.allow_forgery_protection = false
  end

  # The click that queues a request reaches the app server asynchronously:
  # wait for the job to be queued, then run it as Solid Queue would.
  def finish_ai_requests
    Timeout.timeout(5) { sleep 0.05 until enqueued_jobs.any? }
    perform_enqueued_jobs
  end

  let!(:author) { create(:user, password: "secret12345") }
  let!(:article) { create(:article, user: author, published: false, title: "Work in progress", body: "Teh draft text here.") }

  before do
    visit admin_path
    fill_in "Email", with: author.email_address
    fill_in "Password", with: "secret12345"
    click_button "Sign in"
    expect(page).to have_content("Unpublished Articles")
  end

  it "reviews the draft and applies a fix to the body" do
    visit edit_article_path(article)
    click_button "Assistant"
    click_button "Review draft"
    expect(page).to have_content("Working on it")

    finish_ai_requests
    within(".editor-assistant") do
      expect(page).to have_content("Reads well; one wording fix.")
      within(".ai-finding", text: /grammar/i) { click_button "Apply" }
      expect(page).to have_content("Applied.")
    end
    expect(find_field("Body", visible: :all).value).to eq("Teh draft text (fixed) here.")
  end

  it "suggests a title the author can use" do
    visit edit_article_path(article)
    click_button "Assistant"
    click_button "Suggest titles, summary & tags"
    finish_ai_requests

    within(".editor-assistant") do
      within("li", text: "A suggested title") { click_button "Use" }
    end
    expect(find_field("Title", visible: :all).value).to eq("A suggested title")
  end

  it "researches, outlines and starts a draft" do
    visit admin_ai_path
    fill_in "Topic", with: "SQLite in production", match: :first
    click_button "Research"
    expect(page).to have_content("Working on it")

    finish_ai_requests
    expect(page).to have_content("Notes about SQLite in production.")
    expect(page).to have_link("Example source", href: "https://example.com/source")

    click_button "Outline this"
    finish_ai_requests
    expect(page).to have_content("Why it matters")

    click_button "Start a draft from this outline"
    expect(page).to have_content("Draft created from the outline.")
    expect(find_field("Body", visible: :all).value).to include("## Why it matters", "## Sources")
  end
end
