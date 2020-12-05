require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select "div.pagination", count: 1
    assert_select "input[type=file]"
    # Invalid submission
    assert_no_difference "Micropost.count" do
      post microposts_path, params: {micropost: {content: ""}}
    end
    assert_select "div#error_explanation"
    assert_select "a[href=?]", "/?page=2"  # Correct pagination link
    # Valid submission
    content = "This micropost really ties the room together"
    # fixture_file_upload - is rails method for uploading files in tests
    image = fixture_file_upload("test/fixtures/bmw2.png", "image/png")
    assert_difference "Micropost.count", 1 do
      post microposts_path, params: {micropost: {content: content, image: image}}
    end
    micropost  = assigns(:micropost)
    assert micropost.image.attached?
    # Visit different user (no delete links)
    get user_path(users(:archer))
    assert "a", text: "delete", count: 0
  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "34 microposts", response.body
    # User with zero microposts
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "1 micropost", response.body
  end
end


