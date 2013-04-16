class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or root_path
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

  def callback
    user = User.from_omniauth(["omniauth.auth"])
    if user
      cookies.permanent[:remember_token] = user.remember_token
      self.current_user = user
    end
    redirect_back_or root_path
  end
end
