require 'spec_helper' 

describe "Admin Panel", type: :feature do 
  let(:user) { FactoryGirl.create :user, admin: true}

  it "renders the admin panel" do 
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
    visit "/admin"

    expect(page).to have_content "Unpublished Articles"
  end
end