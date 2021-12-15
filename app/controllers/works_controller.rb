class WorksController < ApplicationController
    before_action :logged_in_user, only:[:index,:new,:edit,
                                        :create,:update,:destroy]

    # before_action :admin_or_current, only:[:]

    def new
        @work = current_user.works.build if logged_in?
    end

    def edit
        @work = Work.find(params[:id])
    end

    def create
        @work = current_user.works.build(work_params)
        if @work.save
            flash[:success] = "勤怠情報を作りました"
            redirect_to current_user
        else
            render 'new'
        end
    end

    def update
        @work = Work.find(params[:id])
        if @work.update(work_params)
            flash[:success] = "情報の変更に成功しました"
            redirect_to works_user_path(current_user)
        else
            render 'edit'
        end
    end

    def destroy
        @work = current_user.works.find(params[:id])
        if @work.destroy
            flash[:success] = "削除しました"
            redirect_to works_user_path(@current_user)
        else
            flash[:danger] = "失敗しました"
            redirect_to works_user_path(@current_user)
        end
    end

    private
        def work_params
            params.require(:work).permit(:day,:start,:finish)
        end

        # 正しいユーザーかどうか確認
        def correct_user
            @user = User.find(params[:id])
            redirect_to(root_url) unless current_user?(@user)
        end

        def admin_or_current
            user = User.find(params[:id])
            unless current_user.admin? || current_user?(user)
                flash[:danger] = "権限がありません"
                redirect_to(root_url)
            end
        end
end
