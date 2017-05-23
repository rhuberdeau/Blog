class RegistrationsController < Devise::RegistrationsController

  before_action :one_user_registered?, only: [:new, :create]

  protected

  def one_user_registered?
    if (User.count >= 1)
      redirect_to root_path
    end
  end
end
