class RightsController < ApplicationController
  before_action :admin_user

  def user_update
    @user = User.find(params[:user][:id])
    if @user.update(admin_params)
      flash[:success] = "情報の変更に成功しました"
      redirect_to users_path
    else
      render template: "users/show"
    end
  end

  def work_new
    @user = User.find(params[:id])
    @work = @user.works.build
  end

  def work_create
    @user = User.find(params[:work][:id])
    @work = @user.works.build(work_params)
    date = @work.day
    if @work.save
      flash[:success] = "勤怠情報を作りました"
      redirect_to controller: "users", id: @user.id, action: "works",date: date
    else
      render 'work_new'
    end
  end

  private

  def admin_params
    params.require(:user).permit(:name, :number,:money, :password,
      :password_confirmation)
  end
end
