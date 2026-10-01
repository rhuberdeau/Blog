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

  it "floats the contact form labels and sends a message" do
    visit new_contact_path

    # The theme hides each label until its field has a value.
    group = find_field("Name").ancestor(".floating-label-form-group")
    expect(group).not_to match_css(".floating-label-form-group-with-value")
    fill_in "Name", with: "Ann"
    expect(group).to match_css(".floating-label-form-group-with-value")

    fill_in "Email address", with: "ann@example.com"
    fill_in "Message", with: "Hello"
    click_button "Send"
    expect(page).to have_content("Your message was sent.")
  end
end
