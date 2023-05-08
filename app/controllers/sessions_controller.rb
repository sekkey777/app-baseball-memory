class SessionsController < ApplicationController
  skip_before_action :login_required
  
  def new
  end

  def create
    user = User.find_by(name: params[:session][:name])
    if user&.authenticate(params[:session][:password])
      log_in user
      flash[:success] = 'ログインしました。'
      redirect_to user_path(user)
    else
      flash.now[:danger] = 'ログインに失敗しました。ユーザー名、またはパスワードが違います。'
      render 'new'
    end
  end

  def destroy
    log_out
    flash[:success] = 'ログアウトしました。'
    redirect_to login_path
  end
end
