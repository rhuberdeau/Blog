class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :find_tags
  
  private
  def find_tags
  	@tags = Tag.all
  end
end
