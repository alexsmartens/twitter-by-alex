require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select 'input[name=?]', 'password_reset[email]'

    # Invalid email
    post password_resets_path, params: { password_reset: { email: "" } }
    follow_redirect!
    assert_not flash.empty?
    assert_select "div.alert.alert-info", "Thanks! If you have a Twitter by Alex account, we've sent you an email"

    # Valid email
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    # Get user before redirect, because ofter redirect it will be nil
    # user is needed because reset_token is only stored on this instance variable
    # but not in the database
    user = assigns(:user)
    #
    follow_redirect!
    assert_not flash.empty?
    assert_select "div.alert.alert-info", "Thanks! If you have a Twitter by Alex account, we've sent you an email"

    # Password reset form
    # (1) Right token but wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    follow_redirect!
    assert_not flash.empty?
    assert_select "div.alert.alert-danger", "Incorrect activation token!"

    # (2) Right email but wrong token
    get edit_password_reset_path("wrong_token", email: user.email)
    follow_redirect!
    assert_not flash.empty?
    assert_select "div.alert.alert-danger", "Incorrect activation token!"

    # (3) Inactive user
    # Changes the value of a boolean and skips validation, alternatively
    # user.toggle(:activated).save does not skip validation
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    follow_redirect!
    assert_not flash.empty?
    assert_select "div.alert.alert-danger", "Your account should be activated before proceeding! Please check your email from earlier"
    user.toggle!(:activated)

    # (4) Invalid password & confirmation
    patch password_reset_path(user.reset_token),
      params: { email: user.email,
                user: { password: "foobar1",
                        password_confirmation: "foobar2"
                      }
              }
    assert_select 'div#error_explanation'

    # (5) Empty password
    patch password_reset_path(user.reset_token),
      params: { email: user.email,
                user: { password: "",
                        password_confirmation: "" } }
    assert_select 'div#error_explanation'

    # Valid password & confirmation
    patch password_reset_path(user.reset_token),
      params: { email: user.email,
                user: { password: "foobar",
                        password_confirmation: "foobar" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
    # Make sure the link cannot be used after logging in
    user.reload
    assert_nil user.reset_digest
    assert_nil user.reset_sent_at
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path,
      params: { password_reset: { email: @user.email } }
      user = assigns(:user)
      user.update_attribute(:reset_sent_at, 3.hours.ago)
      patch password_reset_path(user.reset_token),
      params: { email: user.email,
                user: { password: "foobar",
                        password_confirmation: "foobar" } }

      assert_response :redirect
      follow_redirect!
      assert_match "expired", response.body
  end
end
