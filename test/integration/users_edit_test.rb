require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    assert_equal edit_user_url(@user), session[:forwarding_url]
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    follow_redirect!
    assert_template 'users/edit'
    assert_nil session[:forwarding_url]
    name = "Far Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: {
      user: {
        name: name,
        email: email,
        password: "",
        password_confirm: ""
      }
    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {
      user: {
        name: "",
        email: "foo@invalid",
        password: "foo",
        password_confirm: "bar",
      }
    }

    assert_template 'users/edit'

    # Check number of errors [!! UI shows 4 errors in this case]
    assert_select 'div.alert', 'The form contains 3 errors.'
    # assert_select 'div.alert', 'The form contains 4 errors.'

    # Check error messages [this is Alex's idea, hence there is might be a
    # better way to do it]
    assert_select 'li', "Name can't be blank"
    assert_select 'li', "Email is invalid"
    # assert_select 'li', "Password confirmation doesn't match Password"
    assert_select 'li', "Password is too short (minimum is 6 characters)"
  end
end
