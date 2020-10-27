require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "root layout links" do
    get root_path
    assert_template 'static_pages/home'
    # Assert that there are two links <a href="/">...</a> on the page
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end
end
