include ApplicationHelper

class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @micropost = get_current_user.microposts.new
      @feed_items = get_current_user.feed.paginate(page: validate_page_num(params[:page]))
    end
  end

  def help
  end

  def about
  end

  def contact
  end

end
