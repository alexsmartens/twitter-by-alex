
class RelationshipsController < ApplicationController
  before_action :logged_in_user?

  def create
    user = User.find(params[:followed_id])
    get_current_user.follow(user)
    # request.referrer - is the link to the page that issued the request to this
    # action (this is related to the request.original_url). So that,
    # 'redirect_to request.referrer' redirects the request back to the page which
    # issued the request in the first place. Alternative command:
    # redirect_back(fallback_location: root_url)
    redirect_to request.referrer || user
  end

  def destroy
    user = Relationship.find(params[:id]).followed
    get_current_user.unfollow(user)
    # request.referrer - is the link to the page that issued the request to this
    # action (this is related to the request.original_url). So that,
    # 'redirect_to request.referrer' redirects the request back to the page which
    # issued the request in the first place. Alternative command:
    # redirect_back(fallback_location: root_url)
    redirect_to request.referrer || user
  end

end
