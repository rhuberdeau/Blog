class Articles::PublishController < ApplicationController
  before_filter :authenticate_user!
  before_filter :user_must_be_admin

  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(published: true, published_on: Time.now)
      flash[:notice] = "'#{@article.title}' was successfully published."
    else
      flash[:alert] = @article.errors.full_messages.to_sentence
    end
    redirect_to admin_path
  end
end
