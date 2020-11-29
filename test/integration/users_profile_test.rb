require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template "users/show"
    assert_select "title", full_title(@user.name)
    assert_select "h1", text: @user.name
    # The assertion below is the nested syntax for assert_select, it checks for
    # an "img.gravatar" inside an "h1" tag
    assert_select "h1>img.gravatar"
    # response.body - despite its name, contains the full HTML source of the page
    # and not just the page's body. So, if all we care about is that the number
    # of microposts appears SOMEWHERE on the page, we can look for a match in
    # response.body
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
