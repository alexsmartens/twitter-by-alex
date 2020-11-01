class UsersController < ApplicationController

  # Action, that handles get requests to /users/id
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  # Action, that handles post requests /users (by default)
  def create
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save
      redirect_to @user  # the same as redirect_to user_url(@user)
    else 
      render 'new'
    end
  end


  private

    def user_params
      # If a permitted attribute is not present than it is considered to be an 
      # empty string
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
