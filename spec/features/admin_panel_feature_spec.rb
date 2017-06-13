require 'spec_helper'

describe "Admin Panel", type: :feature do
  let(:user) { FactoryGirl.create :user, admin: true}

  before do
    login_as(user, :scope => :user)
  end

  it "renders the admin panel" do
    visit "/admin"

    expect(page).to have_content "Unpublished Articles"
  end
end
