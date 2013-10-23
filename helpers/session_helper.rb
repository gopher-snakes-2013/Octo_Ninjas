module SessionHelper
  def my_movie_list
    @my_movie_list ||= []
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def logged_in?
    session[:user_id]
  end

  def enforce_login
    redirect to '/' unless logged_in?
  end

  def user_exists?(username)
    true if User.find_by_username(username)
  end

  def user_authenticated?
    User.authenticate(params[:username], params[:password])
  end


  def set_user
    @user = User.authenticate(params[:username], params[:password]) || User.create({username: params[:username], email: params[:email], password: params[:password]})
  end

  def set_session
    session[:user_id] = @user.id
  end
end