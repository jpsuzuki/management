class UsersController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:new, :index, :destroy]
  before_action :admin_or_current,  only: :works

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
      redirect_to users_path
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
    @date = Date.parse(params[:date])
    @works = @user.works.where(day:this_month)
    @w_time = 0
    @works.each do |work|
      next if work.finish.nil?
      if work.finish.to_i-work.start.to_i < 0
        @w_time += work.finish.to_i-work.start.to_i+86400
      else
        @w_time += work.finish.to_i-work.start.to_i
      end
    end
    @w_time /= 60
    @money= @user.money.to_f/60
  end

  private

    def user_params
      params.require(:user).permit(:name, :number, :password,
                                   :password_confirmation)
    end

    def admin_params
      params.require(:user).permit(:name, :number,:money, :password,
        :password_confirmation)
    end

    def this_month
      @date = @date.next_month.beginning_of_month if @date.day > 19
      head = Date.new(@date.year,@date.last_month.month,20)
      foot = Date.new(@date.year,@date.month,19)
      head..foot
    end

    # beforeアクション

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(login_url) unless current_user?(@user)
    end

    # 管理者か本人のみ見れる
    def admin_or_current
      @user = User.find(params[:id])
      unless current_user.admin? || current_user?(@user)
          flash[:danger] = "権限がありません"
          redirect_to(root_url)
      end
    end


end