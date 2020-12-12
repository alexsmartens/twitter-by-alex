require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other = users(:archer)
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

  test "should follow a user the standard way" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @other.id }
    end
  end

  test "should follow a user with Ajax" do
    assert_difference '@user.following.count', 1 do
      # 'xhr' attribute stands for XmlHttpRequest; setting xhr to true issues
      # an Ajax request, which causes the respond_to block in the controller to
      # execute the proper JavaScript method
      post relationships_path, params: { followed_id: @other.id }, xhr: true
    end
  end

  test "should unfollow a user the standard way" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow a user with Ajax" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    # 'xhr' attribute stands for XmlHttpRequest; setting xhr to true issues
    # an Ajax request, which causes the respond_to block in the controller to
    # execute the proper JavaScript method
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end

end
