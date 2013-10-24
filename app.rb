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

Rotten.api_key = 'z9rcfwsnkafcdrwpxhqsaqqy'

begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
end

enable :sessions

set :database, ENV['DATABASE_URL'] || "postgres://localhost/ninjadb"

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

get '/' do
  @user = current_user if logged_in?
  erb :index
end

post '/signin' do
  @user = User.authenticate(params[:username], params[:password])
  if !@user.nil?
    session[:user_id] = @user.id
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
  if !check_existing_user(params[:username])
    @user = User.create( {username: params[:username], email: params[:email], password: params[:password]} )
    session[:user_id] = @user.id
  	redirect '/create_survey'
  else
    @error = "That username already exists"
    erb :index
  end
end

get '/create_survey' do
  enforce_login
	session[:movie_list] = []
  @user = current_user
  erb :create_survey
end

post '/add_movie' do
  @user = current_user
	search_title = params[:movie_title]
	@movie_to_add = RottenMovie.find(:title => search_title, :limit => 1)
  

	@my_movie = Movie.create(:title => @movie_to_add.title,
							 			       :synopsis => @movie_to_add.synopsis, 
							 			       :runtime => @movie_to_add.runtime, 
							 			       :critics_score => @movie_to_add.ratings.critics_score, 
							 			       :audience_score => @movie_to_add.ratings.audience_score, 
							 			       :pic => @movie_to_add.posters.original
	)

  session[:movie_list] << @my_movie.title
  @movie_list = session[:movie_list]

	erb :create_survey
end

post '/logout' do
  session.clear
  redirect '/'
end






