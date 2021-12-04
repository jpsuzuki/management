class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(number: params[:session][:number])
    log_out if logged_in?
    if user && user.authenticate(params[:session][:password])
      log_in user
      if user.admin?
        # ここに管理者がリダイレクトするページを記述
        redirect_to user
      else
        redirect_to user
      end
    else
      flash.now[:danger] = '番号とパスワードの組み合わせが正しくありません' 
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
end
