require 'spec_helper'

describe 'article pages' do
  let (:article) { FactoryGirl.create(:article) }

  subject { page }

  describe 'A standard user' do
    let(:user) {FactoryGirl.create(:user) }
    before { assign_cookies user }

    describe  "tries to visit the new article page" do
      before { get new_article_path }
      it { response.should redirect_to(articles_path)}
    end

    describe  "tries to edit an article" do
      before { put article_path(article) }
      specify { response.should redirect_to(articles_path)}
    end

    describe  "tries to delete an article" do
      before { delete article_path(article)}
      specify { response.should redirect_to(articles_path)}
    end

    describe  "tries to post to the create action" do
      before { post articles_path}
      specify { response.should redirect_to(articles_path)}
    end

    describe  "reads an article" do
      before { get article_path(article)}
      it { response.status.should equal(200) }
    end

  end

  describe 'An admin' do
    let(:admin) { FactoryGirl.create(:user, email: "admin@mail.com", admin: true) }
    before { assign_cookies admin }
    
    describe "visits" do
          
      describe  "the create page" do
        before { get new_article_path }
        it { response.status.should equal(200)}
      end

      describe  "the edit article page" do
        before { get edit_article_path(article) }
        it { response.status.should equal(200)}
      end

      describe  "the delete article page" do
        before { delete article_path(article)}
        specify { response.status.should equal(302)}
      end

    end
  end
end