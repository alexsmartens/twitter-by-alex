class StaticPagesController < ApplicationController

  def home
    @micropost = get_current_user.microposts.new if logged_in?
  end

  def help
  end

  def about
  end

  def contact
  end

end
