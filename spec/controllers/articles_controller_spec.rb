require 'spec_helper'

RSpec.describe ArticlesController, :type => :controller do
  describe "GET #index" do 
    it "responds with published articles" do 
      article1 = Article.create!(title: "This is article 1", summary: "An article", body: "This is the article body", user_id: 1 )
      article2 = Article.create!(title: "This is article 2", summary: "An article", body: "This is the article body", user_id: 1, published: true )
      article3 = Article.create!(title: "This is article 3", summary: "An article", body: "This is the article body", user_id: 1 )

      get :index
      expect(assigns(:articles)).to match_array([article2])
    end
  end

  describe "GET #show" do 
    let (:article) { FactoryGirl.create(:article) }

    it "assigns @title" do 
      get :show, id: article.id
      expect(assigns(:title)).to eql(article.title)
    end

    it "assigns @content" do 
      get :show, id: article.id
      expect(assigns(:content)).to eql(article.summary)
    end

    it "assigns @keywords" do 
      get :show, id: article.id
      expect(assigns(:keywords)).to eql(article.title)
    end
  end

  describe "GET #new" do 
    context "when an admin is logged in" do
      let(:user) {FactoryGirl.create(:user, admin: true) }
      before { assign_cookies(user) }

      it "renders the new template" do 
        get :new
        expect(response.status).to eq(200)
      end 
    end

    context "when the user is not an admin" do 
      let(:user) {FactoryGirl.create(:user) }
      before { assign_cookies(user) }

      it "redirects the user" do 
        get :new
        expect(response.status).to eq(302)
      end 
    end

    context "when the user is not logged in" do 
      it "redirects the user" do 
        get :new
        expect(response.status).to eq(302)
      end 
    end
  end

  describe "GET #edit" do 
    let (:article) { FactoryGirl.create(:article) }

    context "when an admin is logged in" do
      let(:user) {FactoryGirl.create(:user, admin: true) }
      before { assign_cookies(user) }

      it "should be a success" do 
        get :edit, id: article.id
        expect(response.status).to eq(200)
      end 
    end

    context "when the user is not an admin" do 
      let(:user) {FactoryGirl.create(:user) }
      before { assign_cookies(user) }

      it "redirects the user" do 
        get :edit, id: article.id
        expect(response.status).to eq(302)
      end 
    end

    context "when the user is not logged in" do 
      it "rredirects the user" do 
        get :edit, id: article.id
        expect(response.status).to eq(302)
      end 
    end
  end

  describe "POST #create" do 
    let(:article_params) { FactoryGirl.attributes_for(:article) }

    context "when an admin is logged in" do
      let(:user) {FactoryGirl.create(:user, admin: true) }
      before { assign_cookies(user) }

      it "should be successful" do 
        post :create, :article => article_params
        expect(response).to redirect_to Article.last
      end 

      it "creates a new article" do 
        expect { post :create, :article => article_params }.to change(Article, :count).by(1)
      end 
    end

    context "when the user is not an admin" do 
      let(:user) {FactoryGirl.create(:user) }
      before { assign_cookies(user) }

      it "does not create a new article" do 
        expect { post :create, :article => article_params }.to change(Article, :count).by(0)
      end 
    end

    context "when the user is not logged in" do 
      it "does not create a new article" do 
        expect { post :create, :article => article_params }.to change(Article, :count).by(0)
      end 
    end
  end

  describe "POST #update" do 
    let(:article) { FactoryGirl.create(:article) }
    let(:article_params) do 
      { body: "Brand new article content. It's much better than the old content" }
    end

    context "when an admin is logged in" do
      let(:user) {FactoryGirl.create(:user, admin: true) }
      before { assign_cookies(user) }

      it "should be successful" do 
        post :update, id: article.id, :article => article_params
        expect(response).to redirect_to article
      end 

      it "updates the articles body"  do 
        post :update, id: article.id, :article => article_params
        article.reload
        expect(article.body).to eql("Brand new article content. It's much better than the old content")
      end
    end

    context "when the user is not an admin" do 
      let(:user) {FactoryGirl.create(:user) }
      before { assign_cookies(user) }

      it "does not update the article" do 
        post :update, id: article.id, :article => article_params
        article.reload
        expect(article.body).to_not eql("Brand new article content. It's much better than the old content")
      end
    end

    context "when the user is not logged in" do 
      it "does not update the article" do 
        post :update, id: article.id, :article => article_params
        article.reload
        expect(article.body).to_not eql("Brand new article content. It's much better than the old content")
      end
    end
  end

  describe "DELETE #delete" do 
    let!(:article) { FactoryGirl.create(:article) }

    context "when an admin is logged in" do
      let(:user) {FactoryGirl.create(:user, admin: true) }
      before { assign_cookies(user) }

      it "should be successful" do 
        delete :destroy, id: article.id
        expect(response).to redirect_to articles_url
      end 

      it "deletes the article" do 
        expect { delete :destroy, id: article.id }.to change(Article, :count).by(-1)
      end
    end

    context "when the user is not an admin" do 
      let(:user) {FactoryGirl.create(:user) }
      before { assign_cookies(user) }

      it "does not delete the article" do
        expect { delete :destroy, id: article.id }.to change(Article, :count).by(0)
      end
    end

    context "when the user is not logged in" do 
      it "does not delete the article" do 
        expect { delete :destroy, id: article.id }.to change(Article, :count).by(0)
      end
    end
  end
end
