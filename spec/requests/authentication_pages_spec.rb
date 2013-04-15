require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('h1', text: 'Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
  	    before { click_link "Home" }
  	    it { should_not have_selector('div.alert.alert-error') }
	  end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end

    describe  "authorization" do
      describe  "for non-signed in users" do
        let (:article) { FactoryGirl.create(:article) }

        describe "when attempting to visit a protected page" do
          before do
            visit edit_user_path(user)
            fill_in "Email",    with: user.email
            fill_in "Password", with: user.password
            click_button "Sign in"
          end

          describe "after signing in" do

            it "should render the desired protected page" do
              page.should have_selector('title', text: 'Edit user')
            end
          end
        end

        describe  "in the Articles controller" do
          describe  "visit the new article page" do
            before { visit new_article_path }
            it { should_not have_selector('h1', text: 'New article') }
          end

          describe  "visit the edit page" do
             before { visit edit_article_path(article) }
             it { should_not have_selector('h1', text: 'Editing article') }
          end

          describe  "submitting to the update action" do
            before { put article_path(article) }
            specify { response.should redirect_to(signin_path)}
          end

          describe  "submitting to the delete action" do
            before { delete article_path(article) }
            specify { response.should redirect_to(signin_path)}
          end

          describe  "submitting to the create action" do
            before { post articles_path }
            specify { response.should redirect_to(signin_path)}
          end

          describe "as wrong user" do
            let(:user) { FactoryGirl.create(:user) }
            let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
            before { sign_in user }

            describe "visiting Users#edit page" do
              before { visit edit_user_path(wrong_user) }
              it { should_not have_selector('h1', text: 'Update your profile') }
            end

            describe "submitting a PUT request to the Users#update action" do
              before { put user_path(wrong_user) }
              specify { response.should redirect_to(root_path) }
            end
          end
        end

        describe  "in the Admin controller" do
          
          describe  "visit the admin page" do
            before { get admin_index_path }
            specify { response.should redirect_to(signin_path)}
          end

          describe  "visit the admin show page" do
            before { get admin_show_path }
            specify { response.should redirect_to(signin_path)}
          end

          describe  "visit the admin manage comments page" do
            before { get admin_manage_comments_path }
            specify { response.should redirect_to(signin_path)}
          end

        end 

      end
    end
  end
end

