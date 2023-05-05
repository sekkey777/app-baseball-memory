class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:session][:name])
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user_path(user)
    else
      flash.now[:danger] = 'ログインに失敗しました。ユーザー名、またはパスワードが違います。'
      render 'new'
    end
  end

  def destroy

  end
end
