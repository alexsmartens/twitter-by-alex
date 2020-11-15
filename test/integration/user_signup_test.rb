require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  def setup
    # This clearing is important for assuring that exactly one message is
    # delivered. Because the deliveries array is global, we have to reset it in
    # the setup method to prevent our code from breaking if any other tests
    # deliver email.
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path

    # Asserts that 'User.count' is the same before and after executing the block
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirm: "bar",
        }
      }
    end

    assert_template 'users/new'

    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count' do
      post users_path, params: {
        user: {
          name: "Example User",
          email: "user@example.com",
          password: "password",
          password_confirm: "password",
        }
      }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size

    # assigns: hash that stores all INSTANCE variables assigned in the actions that
    # are available for the view. For example, the Users controller’s create
    # action defines an @user variable, so we can access it in the test using
    # assigns(:user). The assigns method is deprecated in default Rails tests
    # as of Rails 5, but it is still useful in many contexts, and it’s available
    # via the rails-controller-testing gem. For more:
    # https://guides.rubyonrails.org/v4.2/testing.html
    # https://api.rubyonrails.org/v4.2.5/classes/ActionController/TestCase.html
    user = assigns(:user)
    assert_not user.activated?
    # Try log in before activation
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    # Invalid activation email
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: "wrong")
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name: "Example User",
          email: "user@example.com",
          password: "password",
          password_confirm: "password",
        }
      }
    end
    follow_redirect!
    # assert_template 'users/show'
    # assert flash[:success]
    # assert is_logged_in?
  end
end
