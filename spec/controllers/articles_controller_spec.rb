
RSpec.describe ArticlesController, type: :controller do
  describe "GET #index" do
    it "responds with published articles" do
      article1 = create(:article, title: "This is article 1", summary: "An article", body: "This is the article body", published: false)
      article2 = create(:article, title: "This is article 2", summary: "An article", body: "This is the article body", published: true)
      article3 = create(:article, title: "This is article 3", summary: "An article", body: "This is the article body", published: false)

      get :index
      expect(assigns(:articles)).to match_array([ article2 ])
    end
  end

  describe "GET #show" do
    let (:article) { create(:article) }

    it "renders the article" do
      get :show, params: { id: article.id }
      expect(response.status).to eq(200)
    end
  end

  describe "GET #new" do
    context "when an admin is logged in" do
      let(:user) { create(:user, admin: true) }
      before { sign_in user }

      it "renders the new template" do
        get :new
        expect(response.status).to eq(200)
      end
    end

    context "when the user is not an admin" do
      let(:user) { create(:user) }
      before { sign_in user }

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
    let (:article) { create(:article) }

    context "when an admin is logged in" do
      let(:user) { create(:user, admin: true) }
      before { sign_in user }

      it "should be a success" do
        get :edit, params: { id: article.id }
        expect(response.status).to eq(200)
      end
    end

    context "when the user is not an admin" do
      let(:user) { create(:user) }
      before { sign_in user }

      it "redirects the user" do
        get :edit, params: { id: article.id }
        expect(response.status).to eq(302)
      end
    end

    context "when the user is not logged in" do
      it "rredirects the user" do
        get :edit, params: { id: article.id }
        expect(response.status).to eq(302)
      end
    end
  end

  describe "POST #create" do
    let(:article_params) { attributes_for(:article) }

    context "when an admin is logged in" do
      let(:user) { create(:user, admin: true) }
      before { sign_in user }

      it "should be successful" do
        post :create, params: { article: article_params }
        expect(response).to redirect_to Article.last
      end

      it "creates a new article" do
        expect { post :create, params: { article: article_params } }.to change(Article, :count).by(1)
      end

      it "does not publish the article by default" do
        article_params = attributes_for(:article, published: false)
        post :create, params: { article: article_params }
        article = Article.last
        expect(article.published).to eql(false)
      end
    end

    context "when the user is not an admin" do
      let(:user) { create(:user) }
      before { sign_in user }

      it "does not create a new article" do
        expect { post :create, params: { article: article_params } }.to change(Article, :count).by(0)
      end
    end

    context "when the user is not logged in" do
      it "does not create a new article" do
        expect { post :create, params: { article: article_params } }.to change(Article, :count).by(0)
      end
    end
  end

  describe "POST #update" do
    let(:article) { create(:article) }
    let(:article_params) do
      { body: "Brand new article content. It's much better than the old content" }
    end

    context "when an admin is logged in" do
      let(:user) { create(:user, admin: true) }
      before { sign_in user }

      it "should be successful" do
        post :update, params: { id: article.id, article: article_params }
        expect(response).to redirect_to article
      end

      it "updates the articles body"  do
        post :update, params: { id: article.id, article: article_params }
        article.reload
        expect(article.body).to eql("Brand new article content. It's much better than the old content")
      end
    end

    context "when the user is not an admin" do
      let(:user) { create(:user) }
      before { sign_in user }

      it "does not update the article" do
        post :update, params: { id: article.id, article: article_params }
        article.reload
        expect(article.body).to_not eql("Brand new article content. It's much better than the old content")
      end
    end

    context "when the user is not logged in" do
      it "does not update the article" do
        post :update, params: { id: article.id, article: article_params }
        article.reload
        expect(article.body).to_not eql("Brand new article content. It's much better than the old content")
      end
    end
  end

  describe "DELETE #delete" do
    let!(:article) { create(:article) }

    context "when an admin is logged in" do
      let(:user) { create(:user, admin: true) }
      before { sign_in user }

      it "should be successful" do
        delete :destroy, params: { id: article.id }
        expect(response).to redirect_to articles_url
      end

      it "deletes the article" do
        expect { delete :destroy, params: { id: article.id } }.to change(Article, :count).by(-1)
      end
    end

    context "when the user is not an admin" do
      let(:user) { create(:user) }
      before { sign_in user }

      it "does not delete the article" do
        expect { delete :destroy, params: { id: article.id } }.to change(Article, :count).by(0)
      end
    end

    context "when the user is not logged in" do
      it "does not delete the article" do
        expect { delete :destroy, params: { id: article.id } }.to change(Article, :count).by(0)
      end
    end
  end
end
