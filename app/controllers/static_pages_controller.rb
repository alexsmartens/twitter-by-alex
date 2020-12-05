class StaticPagesController < ApplicationController

  def home
    @micropost = get_current_user.microposts.new if logged_in?
    page_num = params[:page].to_i > 0 ? params[:page] : 1
    @feed_items = get_current_user.feed.paginate(page: page_num)
  end

  def help
  end

  def about
  end

  def contact
  end

end
