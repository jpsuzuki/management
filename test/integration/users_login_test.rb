require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:archer)
  end


  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { number: "", password: "" } }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    get login_path
    post login_path, params: { session: { number:    @user.number,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
  end


end
