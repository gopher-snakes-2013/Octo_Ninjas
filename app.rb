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
require './helpers/session_helper.rb'

begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
end

include RottenTomatoes

Rotten.api_key = ENV['ROTTEN_API_KEY']

helpers do
  include SessionHelper
end

enable :sessions

set :database, ENV['DATABASE_URL']

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
  @user = User.create( {username: params[:username], email: params[:email], password: params[:password]} )
  if @user
    session[:user_id] = @user.id
  	redirect '/create_survey'
  else
    redirect '/register'
  end
end

get '/create_survey' do
	@my_movie_list = []
  enforce_login
  erb :create_survey
end

post '/create_survey' do
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
  logout
  redirect '/'
end






