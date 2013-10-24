module SessionHelper
  def logged_in?
    session[:user_id] ? true : false
  end

  def current_user
    @currrent_user ||= User.find(session[:user_id]) if logged_in?
  end

  def enforce_login
    redirect '/' if !logged_in?
  end

  def logout
    session.clear
  end

end