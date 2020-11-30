class MicropostsController < ApplicationController
  before_action :logged_in_user?, only: [:create, :destroy]

  def create
    @micropost = get_current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
    end
    redirect_to root_url
  end

  def destroy
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end
end