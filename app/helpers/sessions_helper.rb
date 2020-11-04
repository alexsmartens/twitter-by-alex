module SessionsHelper

  # Logs in the given user
  def log_in(user)
    # The session object already exists when the page is loaded, so we just need 
    # to append it with whatever we want to store persistently between user 
    # requests (browsing the website) 
    
    # This places a TEMPORARY cookie on the user’s browser containing an ENCRYPTED 
    # version of the user’s id, , which allows us to retrieve the id on subsequent 
    # pages using session[:user_id]. A temprary cookie expires immediately 
    # when the browser is closed.
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any)
  def current_user
    if session[:user_id]
      # Equivalent to 
      # @current_user =  @current_user || User.find_by(id: session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # Returns true if the user is logged in, false otherwise
  def logged_in?
    !!current_user
  end

  # Logs out the current user
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
