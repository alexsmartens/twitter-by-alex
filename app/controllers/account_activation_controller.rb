class AccountActivationController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.assign_attributes({activated: true, activated_at: Time.zone.now})
      user.save(validate: false)
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    end
  end
end
