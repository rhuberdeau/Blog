# The admin's path through the app, in a real browser: sign in, write an
# article with tags, publish it from the admin panel, and see it on the site.
# Exercises Turbo form submissions (422 on errors, 303 redirects) and the
# button_to forms that replaced rails-ujs links.
RSpec.describe "Publishing an article", type: :system do
  let!(:admin) { create(:user, admin: true, password: "secret12345", password_confirmation: "secret12345") }

  it "goes from draft to the home page" do
    visit new_user_session_path
    fill_in "Email", with: admin.email
    fill_in "Password", with: "secret12345"
    click_button "Log in"
    expect(page).to have_content("Signed in successfully.")

    visit new_article_path
    fill_in "Title", with: "x"
    click_button "Save"
    expect(page).to have_content("The form contains")

    fill_in "Title", with: "Running Rails in Docker"
    fill_in "Summary", with: "Notes from the upgrade"
    fill_in "Body", with: "Some **bold** text"
    fill_in "Tag names", with: "rails, docker"
    click_button "Save"
    expect(page).to have_content("Article was successfully created.")
    expect(page).to have_css("strong", text: "bold")

    visit admin_path
    within("table", match: :first) { click_button "Publish" }
    expect(page).to have_content("'Running Rails in Docker' was successfully published.")

    visit root_path
    click_link "Running Rails in Docker"
    click_link "docker"
    expect(page).to have_content("Tagged “docker”")
    expect(page).to have_content("Running Rails in Docker")

    visit admin_path
    click_button "Logout"
    expect(page).to have_content("Signed out successfully.")
    visit admin_path
    expect(page).to have_current_path(new_user_session_path)
  end
end
