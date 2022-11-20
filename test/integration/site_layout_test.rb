require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "root layout links" do
    get root_path
    assert_template 'static_pages/home_not_logged_in'
    # Assert that there are two links <a href="/">...</a> on the page
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", "https://github.com/alexsmartens"

    get signup_path
    assert_select "title", full_title("Sign up")
  end
end
