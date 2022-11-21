module SessionsHelper

  def get_current_user
    @current_user ||=
      if session[:user_id]
        User.find_by(id: session[:user_id])
      elsif cookies.encrypted[:user_id] && cookies[:remember_token]
        user = User.find_by(id: cookies.encrypted[:user_id])
        if user && user.authenticated?(:remember, cookies[:remember_token])
          user
        else
          nil
        end
      end
  end

  def current_user?(user)
    user && user == get_current_user
  end

  def log_in(user)
    # The session object already exists when the page is loaded, so we just need
    # to append it with whatever we want to store persistently between user
    # requests (browsing the website)

    # This places a TEMPORARY cookie on the user’s browser containing an ENCRYPTED
    # version of the user’s id, which allows us to retrieve the id on subsequent
    # pages using session[:user_id]. A temporary cookie expires immediately
    # when the browser is closed.
    session[:user_id] = user.id

    # Void password reset attributes to eliminate double logging in with the same link
    user.void_password_reset
  end

  def logged_in?
    !!get_current_user
  end

  def log_out
    forget(@current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Remembers a user in a persistent session
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Forget a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Redirects to stored location (or to the default)
  def redirect_back_or(default)
    # The session deletion occurs even though the line with the redirect appears
    # first; (!!) redirects don’t happen until an explicit return or the end of
    # the method, so any code appearing after the redirect is still executed

    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
