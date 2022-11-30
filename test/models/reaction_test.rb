require 'test_helper'

class ReactionTest < ActiveSupport::TestCase
  def setup
    @user1 = users(:michael)
    @user2 = users(:lana)
    @user3 = users(:archer)
    @user4 = users(:malory)
    @user5 = users(:alex)
    @micropost1 = @user1.microposts.create(content: "Lorem ipsum1")
    @micropost2 = @user1.microposts.create(content: "Lorem ipsum2")
    @micropost3 = @user1.microposts.create(content: "Lorem ipsum3")
    @micropost4 = @user1.microposts.create(content: "Lorem ipsum4")
    @micropost5 = @user1.microposts.create(content: "Lorem ipsum5")

    @micropost1.loves.create(user: @user1)
    @micropost1.loves.create(user: @user2)
    @micropost1.loves.create(user: @user3)
    @micropost1.dislikes.create(user: @user4)
    @micropost1.dislikes.create(user: @user5)

    @micropost2.loves.create(user: @user1)
    @micropost3.loves.create(user: @user1)
    @micropost4.loves.create(user: @user1)
    @micropost5.dislikes.create(user: @user1)
    # one more dislike from cat_video_dislike in reactions fixture
  end

  # Part1: reactions on references
  test "reference counters should be correct" do
    assert_equal @micropost1.love_counter, 3
    assert_equal @micropost1.dislike_counter, 2
  end

  test "reference counters should NOT change" do
    @micropost1.loves.create(user: @user1)
    @micropost1.dislikes.create(user: @user4)

    assert_equal 3, @micropost1.love_counter
    assert_equal 2, @micropost1.dislike_counter
  end

  test "reference counters should NOT be changed by invalid reactions" do
    Reaction.create(reference: @micropost1, reaction_type: "love")
    Reaction.create(reference: @micropost1, reaction_type: "dislike")
    Reaction.create(reference: @micropost1, user: @user1)

    assert_equal 3, @micropost1.love_counter
    assert_equal 2, @micropost1.dislike_counter
  end

  test "reference counters should be updated appropriately" do
    @micropost1.dislikes.create(user: @user1)
    assert_equal 2, @micropost1.love_counter
    assert_equal 3, @micropost1.dislike_counter

    @micropost1.dislikes.create(user: @user2)
    assert_equal 1, @micropost1.love_counter
    assert_equal 4, @micropost1.dislike_counter

    @micropost1.loves.create(user: @user5)
    assert_equal 2, @micropost1.love_counter
    assert_equal 3, @micropost1.dislike_counter

    @user_0 =  users(:user_0)
    @micropost1.loves.create(user: @user_0)
    assert_equal 3, @micropost1.love_counter
    assert_equal 3, @micropost1.dislike_counter
  end

  # Part2: reactions on users
  test "user counters should be correct" do
    assert_equal 4, @user1.loves.count
    assert_equal 2, @user1.dislikes.count
  end

  test "user counters should NOT change" do
    @micropost1.loves.create(user: @user1)
    @micropost5.dislikes.create(user: @user1)
    assert_equal 4, @user1.loves.count
    assert_equal 2, @user1.dislikes.count
  end

  test "user counters should NOT be changed by invalid reactions" do
    Reaction.create(user: @user1, reaction_type: "love")
    Reaction.create(user: @user1, reaction_type: "dislike")
    Reaction.create(user: @user1, reference: @micropost1)

    assert_equal 4, @user1.loves.count
    assert_equal 2, @user1.dislikes.count
  end

  test "user counters should be updated appropriately" do
    @user1.dislikes.create(reference: @micropost1)
    assert_equal 3, @user1.loves.count
    assert_equal 3, @user1.dislikes.count

    @user1.dislikes.create(reference: @micropost2)
    assert_equal 2, @user1.loves.count
    assert_equal 4, @user1.dislikes.count

    @user1.loves.create(reference: @micropost5)
    assert_equal 3, @user1.loves.count
    assert_equal 3, @user1.dislikes.count
  end
end
