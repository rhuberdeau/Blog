class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
    def user_must_be_admin
      unless current_user.try(:admin?)
        redirect_to(articles_path)
      end
    end
end

