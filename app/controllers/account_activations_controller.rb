class AccountActivationsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]

  def edit
    @user.activate
    log_in @user
    flash[:success] = "Account activated!"
    redirect_back_or root_url
  end

  private
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user
    def valid_user
      unless @user && !@user.activated? && @user.authenticated?(:activation, params[:id])
        if @user && @user.activated?
          flash[:danger] = "Your account is already activated!"
        else
          flash[:danger] = "Incorrect activation link!"
        end
        redirect_to root_url
      end
    end

end
