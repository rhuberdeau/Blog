# What a reader's browser does with the Stimulus controllers that replaced
# the theme's jQuery.
RSpec.describe "Reading the site", type: :system do
  it "opens the collapsed menu on a narrow screen" do
    page.driver.browser.manage.window.resize_to(500, 900)
    visit root_path

    expect(page).not_to have_link("About")
    click_button "Toggle navigation"
    expect(page).to have_link("About")
  ensure
    page.driver.browser.manage.window.resize_to(1400, 1000)
  end
end
