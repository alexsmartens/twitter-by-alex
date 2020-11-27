class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]

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

  private
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user
    def valid_user
      unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
        flash[:warning] = "Incorrect activation token!"
        redirect_to root_url
      end
    end
end
