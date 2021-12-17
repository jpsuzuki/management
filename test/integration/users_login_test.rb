require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @admin = users(:michael)
    @user = users(:archer)
    @other = users(:suzuki)
  end


  test "invalid login" do
    get login_path
    assert_template 'sessions/new'
    post login_path, 
      params: { session: { number: "", password: "" } }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get login_path
    assert flash.empty?
  end

  test "user login" do
    get login_path
    post login_path,  
      params: { 
        session: { 
          number: @user.number,
          password: 'password' 
        } 
      }
    assert is_logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to login_url
  end

  test "admin login" do
    get login_path
    post login_path, 
        params: { 
          session: { 
            number:    @admin.number,
            password: 'password' 
          } 
        }
    assert is_logged_in?
    assert_redirected_to users_path
    follow_redirect!
    assert_template 'users/index'
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to login_url
  end

  test "another login while logged in" do
    get login_path
    post login_path,  
      params: { 
        session: { 
          number: @user.number,
          password: 'password' 
        } 
      }
    assert is_logged_in?
    assert session[:user_id]==@user.id
    # assert current_user?(@user)
    get login_path
    post login_path,  
      params: { 
        session: { 
          number: @other.number,
          password: 'password' 
        } 
      }
    assert is_logged_in?
    assert session[:user_id]==@other.id
    assert_not session[:user_id]==@user.id
  end
end