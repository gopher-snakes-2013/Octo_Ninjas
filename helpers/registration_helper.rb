module RegistrationHelper
  def current_user
    @current_user ||= logged_in? && User.find(session[:user_id])
  end

  def logged_in?
    session[:user_id]
  end

  def enforce_login
    redirect to '/' if !logged_in?
  end

  def check_existing_user(username)
    if user = User.find_by_username(username)
      return user
    else
      return false
    end
  end

  def make_active(user)
    session[:user_id] = user.id
  end

  def logout
    session.clear
  end

end
