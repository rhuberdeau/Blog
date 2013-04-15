class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  private
    def authenticate_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def user_must_be_admin
      unless current_user.admin == true
        redirect_to(articles_path)
      end
    end
end

