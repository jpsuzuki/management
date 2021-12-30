class ApplicationController < ActionController::Base
    include SessionsHelper

    private
    # ログイン済みユーザーかどうか確認
        def logged_in_user
            unless logged_in?
                flash[:danger] = "ログインしてください"
                redirect_to login_url
            end
        end

        def admin_user
            unless current_user.admin?
              flash[:danger] = "権限がありません"
              redirect_to(root_url) 
            end
        end

        def work_params
            params.require(:work).permit(:day,:start,:finish)
        end

end
