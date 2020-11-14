require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup informaption" do
    get signup_path

    # Asserts that 'User.count' is the same before and after executing the block
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: "",
          email: "user@inv",
          password: "foo",
          password_confirm: "bar",
        }
      }
    end

    assert_template 'users/new'

    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
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
