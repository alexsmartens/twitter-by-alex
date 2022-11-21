class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    # 1. Authenticate is provided by has_secure_password
    # 2. 'obj&.method' is the same as 'obj && obj.method'
    if @user&.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        remember(@user) if params[:session][:remember_me] == '1'
        redirect_back_or root_url
      else
        message = "Account not activated. "
        message += "Check your email for the activation link"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to  root_url
  end
end
