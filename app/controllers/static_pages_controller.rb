class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @micropost = get_current_user.microposts.new
      page_num = params[:page].to_i > 0 ? params[:page] : 1
      @feed_items = get_current_user.feed.paginate(page: page_num)
    end
  end

  def help
  end

  def about
  end

  def contact
  end

end
