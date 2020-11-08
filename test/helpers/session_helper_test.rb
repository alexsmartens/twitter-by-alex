require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    remember(@user)
  end

  test "get_current_user returns right user when session is nil" do
    # !! conventional order for the arguments to assert_equal:
    # assert_equal <expected>, <actual>
    assert_equal @user, get_current_user
    assert is_logged_in?
  end

  test "get_current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil get_current_user
  end
end