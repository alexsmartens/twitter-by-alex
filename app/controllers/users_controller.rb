class UsersController < ApplicationController
  before_action :logged_in_user?, only: [:index, :edit, :update, :destroy]
  before_action :correct_user?, only: [:edit, :update]
  before_action :admin_user?, only: :destroy

  # [GET] Handles requests to /users
  def index
    page_num = params[:page].to_i > 0 ? params[:page].to_i : 1
    @users = User.paginate(page: page_num)
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

  # [DELETE] Deletes users, requests to /users/id
  def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:success] = "User #{user.name} deleted"
    redirect_to users_url
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

    def logged_in_user?
      unless logged_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_url
      end
    end

    # Confirms the user attempts to do an action on him-/herself
    def correct_user?
      @user = User.find(params[:id])
      unless  current_user?(@user)
        flash[:danger] = "Access denied"
        redirect_to(root_url)
      end
    end

    # Confirms that the user is admin
    def admin_user?
      redirect_to(root_url) unless get_current_user.admin?
    end
end
