require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "login with valid information followed by logout" do
    # 1. Visit the login path
    get login_path
    # 2. Verify that the new sessions form renders properly
    assert_template 'sessions/new'
    # 3. Post valid information to the sessions path
    post login_path, params: { session: {email: @user.email, password: "password" } }
    # 4.1. Assert user logged in
    assert is_logged_in?
    # 4.2. Assert that the user is redirected to his page
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    # 5. Verify that the login link disappears.
    # Assert that there are N links <a href="/">...</a> on the page
    assert_select "a[href=?]", login_path, count: 0
    # 6. Verify that a logout link appears
    assert_select "a[href=?]", logout_path, count: 1
    # 7. Verify that a profile link appears
    assert_select "a[href=?]", user_path(@user), count: 1

    # Log out
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking to clicking logout in a second window
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with valid email/invalid password" do
    # 1. Visit the login path.
    get login_path
    # 2. Verify that the new sessions form renders properly.
    assert_template 'sessions/new'
    # 3. Post to the sessions path with an invalid params hash.
    post login_path, params: { session: {email: @user.email, password: "invalid" } }
    # 4.1. Verify not logged in
    assert_not is_logged_in?
    # 4.2. Verify that the new sessions form gets re-rendered and that a flash message appears
    assert_template 'sessions/new'
    assert_not flash.empty?
    # 5. Visit another page (such as the Home page).
    get root_path
    # 6. Verify that the flash message doesn’t appear on the new page.
    assert flash.empty?
  end

  test "login with invalid information" do
    # 1. Visit the login path.
    get login_path
    # 2. Verify that the new sessions form renders properly.
    assert_template 'sessions/new'
    # 3. Post to the sessions path with an invalid params hash.
    post login_path, params: { session: {email: "", password: "" } }
    # 4.1. Verify not logged in
    assert_not is_logged_in?
    # 4.2. Verify that the new sessions form gets re-rendered and that a flash message appears
    assert_template 'sessions/new'
    assert_not flash.empty?
    # 5. Visit another page (such as the Home page).
    get root_path
    # 6. Verify that the flash message doesn’t appear on the new page.
    assert flash.empty?
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    # assigns: hash that stores all INSTANCE variables assigned in the actions that
    # are available for the view. For example, the Users controller’s create
    # action defines an @user variable, so we can access it in the test using
    # assigns(:user). The assigns method is deprecated in default Rails tests
    # as of Rails 5, but it is still useful in many contexts, and it’s available
    # via the rails-controller-testing gem. For more:
    # https://guides.rubyonrails.org/v4.2/testing.html
    # https://api.rubyonrails.org/v4.2.5/classes/ActionController/TestCase.html
    assert_equal cookies[:remember_token], assigns(:user).remember_token
  end

  test "login without remembering" do
    # Log in to set the cookie
    log_in_as(@user, remember_me: '1')
    # Log in again and verify that the cookie is deleted
    log_in_as(@user, remember_me: '0')
    assert_empty cookies[:remember_token]
  end
end
