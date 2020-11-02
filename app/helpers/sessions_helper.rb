module SessionsHelper

  # Log in the given user
  def log_in(user)
    # This places a TEMPORARY cookie on the user’s browser containing an ENCRYPTED 
    # version of the user’s id, , which allows us to retrieve the id on subsequent 
    # pages using session[:user_id]. A temprary cookie expires immediately 
    # when the browser is closed.
    session[:user_id] = user.id
  end
end
