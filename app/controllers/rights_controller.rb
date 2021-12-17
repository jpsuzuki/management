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

  private

  def admin_params
    params.require(:user).permit(:name, :number,:money, :password,
      :password_confirmation)
  end
end
