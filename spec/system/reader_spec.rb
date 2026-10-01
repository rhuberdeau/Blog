# The site at phone width: the nav is plain links (no menu toggle), and
# nothing should force sideways scrolling, including long code lines.
RSpec.describe "Reading on a phone", type: :system do
  let(:author) { create(:user) }

  it "shows the nav and keeps the page within the screen" do
    article = create(:article, user: author, body: "```ruby\n#{'very_long_identifier_' * 10}\n```")
    page.driver.browser.manage.window.resize_to(390, 844)

    [ root_path, article_path(article), about_path ].each do |path|
      visit path
      expect(page).to have_link("Home")
      expect(page).to have_link("About")
      overflow = page.evaluate_script("document.documentElement.scrollWidth - document.documentElement.clientWidth")
      expect(overflow).to be <= 0, "#{path} scrolls sideways by #{overflow}px"
    end
  ensure
    page.driver.browser.manage.window.resize_to(1400, 1000)
  end
end
