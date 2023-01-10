class SessionsController < ApplicationController
  def new
    # Serves login view
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        if params[:session][:remember_me] == '1'
          remember(@user)
        else
          #TODO: develop a flow for the user to be remembered on multiple devices
          # and not to be forgotten when they log in from a friend's computer
          # and don't click "remember me". This should include a way to forcibly
          # forget all stored session tokens.
          forget(@user)
        end
        redirect_back_or root_url
      else
        message = "Account not activated. Check your email for the activation link"
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
    redirect_to root_url
  end
end
