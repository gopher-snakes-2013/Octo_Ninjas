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

# store key locally in env, don't publish to github
Rotten.api_key = 'z9rcfwsnkafcdrwpxhqsaqqy'

begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
end

enable :sessions

LOCAL_DATABASE_LOCATION = "postgres://localhost/ninjadb"

set :database, ENV['DATABASE_URL'] || LOCAL_DATABASE_LOCATION

def current_user
  @current_user ||= logged_in? && User.find(logged_in?)
end

def logged_in?
  session[:user_id]
end

def enforce_login
  redirect to '/' if !logged_in?
end

get '/' do
  @user = current_user if logged_in?
  erb :index
end

post '/signin' do
  @user = User.authenticate(params[:username], params[:password])
  if @user
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
    @user = User.create( {username: params[:username], email: params[:email], password: params[:password]} )
    session[:user_id] = @user.id
  	redirect '/create_survey'
end

get '/create_survey' do
	@my_movie_list = []
	
  enforce_login
  @user = current_user
  erb :create_survey
end

post '/create_survey' do
  @user = current_user
	my_title = params[:movie_title]
	@my_movie_list = []
  # how will you handle multiple movies with same title, e.g. lotr?
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






