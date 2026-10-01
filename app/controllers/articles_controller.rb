class ArticlesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
  before_action :set_article, only: [ :show, :edit, :update, :destroy ]

  PER_PAGE = 5

  # Newest first, five a page, with Newer/Older links (the theme's pager).
  # Fetching one extra row says whether an older page exists without a count.
  def index
    page = [ params[:page].to_i, 1 ].max
    articles = Article.published.order(published_at: :desc)
      .offset((page - 1) * PER_PAGE).limit(PER_PAGE + 1).to_a

    @articles   = articles.first(PER_PAGE)
    @newer_page = page - 1 if page > 1
    @older_page = page + 1 if articles.size > PER_PAGE
  end

  def show
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = Current.user.articles.build(article_params)

    if @article.save
      redirect_to @article, notice: "Article was successfully created."
    else
      # Turbo only re-renders a failed form submission on a 4xx response.
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: "Article was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_url, status: :see_other
  end

  private

    def set_article
      # Drafts exist only for the author; to anyone else they are a 404.
      scope = authenticated? ? Article.all : Article.published
      @article = scope.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :body, :tag_names, :published, :summary)
    end
end
