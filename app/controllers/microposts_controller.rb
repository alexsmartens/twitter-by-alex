class MicropostsController < ApplicationController
  before_action :logged_in_user?, only: [:create, :destroy]
  before_action :correct_user?, only: :destroy

  def create
    @micropost = get_current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
    end
    redirect_to root_url
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted!"
    # request.referrer - is the link to the page that issued the request to this
    # action (this is related to the request.original_url). So that,
    # 'redirect_to request.referrer' redirects the request back to the page which
    # issued the request in the first place. Alternative command:
    # redirect_back(fallback_location: root_url)
    redirect_to request.referrer || root_url
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user?
      @micropost = get_current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
