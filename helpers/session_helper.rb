module SessionHelper
  def current_user
    @current_user ||= logged_in? && User.find(session[:user_id])
  end

  def logged_in?
    session[:user_id]
  end

  def enforce_login
    redirect to '/' if !logged_in?
  end

  def username_is_unique?(username)
    User.find_by_username(username) ? true : false
  end

  def logout
    session.clear
  end

  def create_user
    User.create( {username: params[:username], email: params[:email], password: params[:password]} )
  end
end