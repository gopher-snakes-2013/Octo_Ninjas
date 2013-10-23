require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'
require 'securerandom'
require 'rottentomatoes'

require './models/movie'
require './models/survey'
require './models/survey_movie'
require './models/user'
require './models/vote'

include RottenTomatoes


begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
end

Rotten.api_key = ENV['ROTTEN_API_KEY']

enable :sessions

LOCAL_DATABASE_LOCATION = "postgres://localhost/ninjadb"
set :database, ENV['DATABASE_URL'] || LOCAL_DATABASE_LOCATION

helpers do
  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def logged_in?
    session[:user_id] != nil
  end

  def enforce_login
    redirect to '/' if !logged_in?
  end

  def create_user(params)
    User.create( {username: params[:username], email: params[:email], password: params[:password]} )
  end

  def existing_user?(username)
    User.find_by_username(username) ? true : false
  end

  def set_active_user(user_id)
    session[:user_id] = user_id 
  end

end

get '/' do
  @user = current_user if logged_in?
  erb :index
end

post '/signin' do
  @user = User.authenticate(params[:username], params[:password])
  if @user != nil
    set_active_user(@user.id)
    redirect '/create_survey'
  else
    @error = "Wrong username or password"
    erb :index
  end
end

get '/register' do
	erb :register
end

post '/register' do
  if existing_user?(params[:username])
    @error = "That username already exists"
    erb :index
  else
    @user = create_user(params)
    set_active_user(@user.id)
    redirect '/create_survey'
  end
end

get '/create_survey' do
  enforce_login
  @my_movie_list = []
  
  @user = current_user
  erb :create_survey
end

post '/create_survey' do
  @user = current_user
  my_title = params[:movie_title]
  @my_movie_list = []
  @my_movie = RottenMovie.find(:title => my_title, :limit => 1)

  @my_movie_list << Movie.create(:title => @my_movie.title,
    :synopsis => @my_movie.synopsis, 
    :runtime => @my_movie.runtime, 
    :critics_score => @my_movie.ratings.critics_score, 
    :audience_score => @my_movie.ratings.audience_score, 
    :pic => @my_movie.posters.original
    )
  erb :create_survey
end

post '/logout' do
  session.clear
  redirect '/'
end






