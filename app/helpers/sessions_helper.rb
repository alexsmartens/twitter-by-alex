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

  # Remembers a user in a persistent session
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns the current logged-in user (if any)
  def current_user
    if @current_user
      @current_user
    elsif session[:user_id]
      # Equivalent to
      # @current_user =  @current_user || User.find_by(id: session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    elsif cookies.encrypted[:user_id] && cookies[:remember_token]
      user = User.find_by(id: cookies.encrypted[:user_id])
      if user&.authenticated?(cookies[:remember_token])
        @current_user = user
      end
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
