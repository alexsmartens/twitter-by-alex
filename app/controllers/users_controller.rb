class UsersController < ApplicationController

  # [GET] Handles requests to /users/id
  def show
    @user = User.find(params[:id])
  end

  # [GET] Signup page
  def new
    @user = User.new
  end

  # [POST] Handles requests to /users/id
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

  # [PATCH] Handles PATCH requests to /users/id/edit
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      #
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
end
