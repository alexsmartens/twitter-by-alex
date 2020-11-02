class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # authenticate is provided by has_secure_password
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user  # same as 'redirect_to user_url(user)'
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
  end
end
