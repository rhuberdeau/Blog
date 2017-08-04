class Articles::PublishController < ApplicationController
  def update
    @article = Article.find(params[:id])
    respond_to do |format|
      if @article.update_attributes(published: true, published_on: Time.now)
        flash[:notice] = "'#{@article.title}' was successfully published."
        format.html { redirect_to admin_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end
end
