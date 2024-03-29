require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

    def setup
        @admin = users(:michael)
        @user = users(:archer)
        @other = users(:suzuki)
    end
    
    test "should redirect edit when not logged in" do
        get edit_user_path(@user)
        assert_not flash.empty?
        assert_redirected_to login_url
    end
    
    test "should redirect update when not logged in" do
        patch user_path(@user), params: { user: { name: @user.name,
                                                  number: @user.number } }
        assert_not flash.empty?
        assert_redirected_to login_url
    end

    test "should redirect edit when logged in as wrong user" do
        log_in_as(@other)
        get edit_user_path(@user)
        assert flash.empty?
        assert_redirected_to login_url
    end
    
      
    test "should redirect update when logged in as wrong user" do
        log_in_as(@other)
        patch user_path(@user), params: { user: { name: @user.name,
                                                   number: @user.number } }
        assert flash.empty?
        assert_redirected_to login_url
    end
    
    test "should not allow the admin attribute to be edited via the web" do
        log_in_as(@other)
        assert_not @other.admin?
        patch user_path(@other), params: {
                                        user: { password:              "password",
                                                password_confirmation: "password",
                                                admin: true } }
        assert_not @other.reload.admin?
    end

    test "should redirect destroy when not logged in" do
        assert_no_difference 'User.count' do
          delete user_path(@user)
        end
        assert_not flash.empty?
        assert_redirected_to login_url
    end
    
    test "should redirect destroy when logged in as a non-admin" do
        log_in_as(@other)
        assert_no_difference 'User.count' do
            delete user_path(@user)
        end
        assert_not flash.empty?
        assert_redirected_to root_url
    end



end
