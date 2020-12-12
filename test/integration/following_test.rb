require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    log_in_as(@user)
  end

  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?  # this is important, because if this
    # statement were true then not a single assert_select would execute in the
    # loop giving us false sense of security
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select ".user_avatars a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?  # this is important, because if this
    # statement were true then not a single assert_select would execute in the
    # loop giving us false sense of security
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select ".user_avatars a[href=?]", user_path(user)
    end
  end
end
