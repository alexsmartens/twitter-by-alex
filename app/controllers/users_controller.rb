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
    else 
      render 'new'
    end
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
