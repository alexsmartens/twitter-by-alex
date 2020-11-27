class PasswordResetsController < ApplicationController
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
end
