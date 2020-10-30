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
end
