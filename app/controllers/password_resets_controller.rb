class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]


  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
    end
    flash[:info] = "Thanks! If you have a Twitter by Alex account, we've sent you an email"
    redirect_to root_url
  end

  def edit
  end

  def update
    if @user.update(user_params)
      log_in @user
      flash[:success] = "Password has been reset"
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
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user
    def valid_user
      unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
        flash[:danger] = "Incorrect activation token!"
        redirect_to root_url
      end
    end

    # Checks expiration of reset token
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired! Try again"
        redirect_to new_password_reset_url
      end
    end
end
