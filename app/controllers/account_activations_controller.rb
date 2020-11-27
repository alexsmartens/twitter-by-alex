class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      if user && user.activated?
        flash[:warning] = "Your account is already activated!"
      else
        flash[:warning] = "Incorrect activation token!"
      end
      redirect_to root_url
    end
  end
end
