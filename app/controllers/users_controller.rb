class UsersController < ApplicationController
  before_filter :authenticate_user, :except => [:new, :create, :show]
  before_filter :correct_user, only: [:edit, :update ]
  before_filter :admin_user,     only: :destroy
  
  def index
    redirect_to root_path
  end

  def show
    @user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the machine!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :role_id, :username, :bio, :approved, :provider, :uid)
    end
end