class Articles::PublishController < ApplicationController
  def update
    @article = Article.find(params[:id])
    if @article.update(published: true)
      flash[:notice] = "'#{@article.title}' was successfully published."
    else
      flash[:alert] = @article.errors.full_messages.to_sentence
    end
    redirect_to admin_path
  end
end
