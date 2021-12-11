class UsersController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user,   only: [:edit, :update]
  # before_action :admin_user,     only: [:new, :index, :destroy]
  before_action :admin_or_current,  only:[:show, :works]

  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "ユーザの作成に成功しました"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "情報の変更に成功しました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "削除しました"
    redirect_to users_url
  end

  def works
    @user = User.find(params[:id])
    @works = @user.works
  end

  private

    def user_params
      params.require(:user).permit(:name, :number, :password,
                                   :password_confirmation)
    end

    # beforeアクション

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      unless current_user.admin?
        flash[:danger] = "権限がありません"
        redirect_to(root_url) 
      end
    end

    # 管理者か本人のみ見れる
    def admin_or_current
      user = User.find(params[:id])
      unless current_user.admin? || current_user?(user)
          flash[:danger] = "権限がありません"
          redirect_to(root_url)
      end
  end


end
