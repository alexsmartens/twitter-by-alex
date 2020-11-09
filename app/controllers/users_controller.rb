class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

  # [GET] Handles requests to /users
  def index
    @users = User.all
  end

  # [GET] Handles requests to /users/id
  def show
    @user = User.find(params[:id])
  end

  # [GET] Signup page
  def new
    @user = User.new
  end

  # [POST] Creates new users based on the sign up requests, requests to /users/id
  def create
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save
      log_in @user
      flash[:success] = "Welcome to the Twitter Sample App!"
      redirect_to @user  # the same as redirect_to user_url(@user)
    else
      render 'new'
    end
  end

  # [GET] Handles requests to /users/id/edit
  def edit
    @user = User.find(params[:id])
  end

  # [PATCH] Updates user info, requests to /users/id
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      # 1. Only permitted attributes can be assigned/dealt with in this way, this
      # avoids assigning the attributes that are not intended to be assigned by
      # the users.
      # 2. If a permitted attribute is not present than it is considered to be an
      # empty string
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      unless  current_user?(@user)
        flash[:danger] = "Access denied"
        redirect_to(root_url)
      end
    end
end
