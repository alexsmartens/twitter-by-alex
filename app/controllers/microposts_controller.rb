include ApplicationHelper

class MicropostsController < ApplicationController
  before_action :logged_in_user?, only: [:create, :destroy]
  before_action :correct_user?, only: :destroy

  def create
    @micropost = get_current_user.microposts.new(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      # This case requires rendering the page because redirecting would never
      # show errors keeping the user uniformed if the post was not saved and why
      @feed_items = get_current_user.feed.paginate(page: validate_page_num(params[:page]))
      render 'static_pages/home'
    end
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
      params.require(:micropost).permit(:content, :image)
    end

    def correct_user?
      @micropost = get_current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
