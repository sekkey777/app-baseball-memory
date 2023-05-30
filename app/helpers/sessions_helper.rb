module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def log_in_guest_user(user)
    session[:user_id] = user.id
    session[:guest] = "guest_user"
  end

  def log_out
    session.delete(:user_id)
    session.delete(:guest) if session[:guest]
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    !current_user.nil?
  end
end
