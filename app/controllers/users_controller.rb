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


  private

    def user_params
      # If a permitted attribute is not present than it is considered to be an
      # empty string
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
