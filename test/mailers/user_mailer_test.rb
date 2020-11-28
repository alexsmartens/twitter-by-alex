require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  def setup
    @user = users(:michael)
  end

  test "account_activation" do
    @user.activation_token = User.new_token
    mail = UserMailer.account_activation(@user)

    assert_equal "[noreply] Account activation: Twitter by Alex", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["twitter.by.alex@gmail.com"], mail.from
    assert_match @user.name, mail.body.encoded
    assert_match @user.activation_token, mail.body.encoded
    assert_match CGI.escape(@user.email), mail.body.encoded
  end

  test "password_reset" do
    @user.reset_token = User.new_token
    mail = UserMailer.password_reset(@user)

    assert_equal "[noreply] Password recovery: Twitter by Alex", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["twitter.by.alex@gmail.com"], mail.from
    assert_match @user.name, mail.body.encoded
    assert_match @user.reset_token, mail.body.encoded
    assert_match CGI.escape(@user.email), mail.body.encoded
  end
end
