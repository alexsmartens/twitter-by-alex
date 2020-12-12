
class RelationshipsController < ApplicationController
  before_action :logged_in_user?

  def create
    @user = User.find(params[:followed_id])
    get_current_user.follow(@user)
    # Process an Ajax request (add a web-service support to the action)
    respond_to do |format|
      # Generates the response in one of the formats listed below, depending on
      # what format the client has requested. More info: https://api.rubyonrails.org/classes/ActionController/MimeResponds.html#method-i-respond_to
      format.html { redirect_to @user }  # respond to the client in html format
      format.js  # this line allows the controller to respond to an Ajax
      # request. More specifically, it responds with an RJS* request and the
      # controller renders the RJS template associated with this action.
      #
      # RJS ("ruby-to-js" template system) is a template (*.js.erb) that generates
      # JavaScript which is executed in an eval block by the browser in response
      # to an AJAX request.
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    get_current_user.unfollow(@user)
    # Process an Ajax request (add a web-service support to the action)
    respond_to do |format|
      # Generates the response in one of the formats listed below, depending on
      # what format the client has requested. More info: https://api.rubyonrails.org/classes/ActionController/MimeResponds.html#method-i-respond_to
      format.html { redirect_to @user }  # respond to the client in html format
      format.js  # this line allows the controller to respond to an Ajax
      # request. More specifically, it responds with an RJS* request and the
      # controller renders the RJS template associated with this action.
      #
      # RJS ("ruby-to-js" template system) is a template (*.js.erb) that generates
      # JavaScript which is executed in an eval block by the browser in response
      # to an AJAX request.
    end
  end

end
