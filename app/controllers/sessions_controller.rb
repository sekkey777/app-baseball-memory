class SessionsController < ApplicationController
  skip_before_action :login_required

  def new
  end

  def create
    if params[:guest_login].present?
      # ゲストログイン処理を実行
      guest_user = User.find_or_create_by(name: 'guest_user') do |user|
        user.name = 'guest_user'
        user.email = SecureRandom.urlsafe_base64 + '@appbaseballmemory.com'
        user.password = SecureRandom.urlsafe_base64
      end
      guest_user.save
      log_in_guest_user guest_user
      flash[:success] = 'ゲストユーザーとしてログインしました'
      redirect_to posts_path
    else
      # 通常のユーザーログインの処理を実行
      user = User.find_by(name: params[:session][:name])
      if user&.authenticate(params[:session][:password])
        log_in user
        flash[:success] = 'ログインしました。'
        redirect_to posts_path
      else
        flash.now[:danger] = 'ログインに失敗しました。ユーザー名、またはパスワードが違います。'
        render 'new'
      end
    end
  end

  def destroy
    log_out
    flash[:success] = 'ログアウトしました。'
    redirect_to login_path
  end
end
