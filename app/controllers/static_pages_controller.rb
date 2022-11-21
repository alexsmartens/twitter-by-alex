include ApplicationHelper

class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @micropost = get_current_user.microposts.new
      @feed_items = get_current_user.feed.paginate(page: validate_page_num(params[:page]))
      return render "home_logged_in"
    end

    render "home_not_logged_in"
  end

  def help
  end

  def about
  end

end
