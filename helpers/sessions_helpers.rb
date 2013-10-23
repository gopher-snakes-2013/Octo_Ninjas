module SessionsHelpers
  def set_active(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if logged_in?
  end

  def logged_in?
    session[:user_id]
  end

  def enforce_login
    redirect to '/' unless logged_in?
  end

  def user_exists?(username)
    User.find_by_username(username)
  end

end
