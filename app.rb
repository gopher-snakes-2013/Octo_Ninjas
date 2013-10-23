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
require './helpers/registration_helper'
require './helpers/movie_helper'

include RottenTomatoes

Rotten.api_key = 'z9rcfwsnkafcdrwpxhqsaqqy'

begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
end

enable :sessions

set :database, ENV['DATABASE_URL'] || "postgres://localhost/ninjadb"

helpers do
  include RegistrationHelper
  include MovieHelper
end

get '/' do
  @user = current_user if logged_in?
  erb :index
end

post '/signin' do
  @user = User.authenticate(params)
  if !@user.nil?
    make_active(@user)
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
    make_active(@user)
  	redirect '/create_survey'
  else
    @error = "That username already exists"
    erb :index
  end
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
	@my_movie = RottenMovie.find(:title => my_title, :limit => 1)

  @my_movie_list << create_movie(@my_movie)

	erb :create_survey
end

post '/logout' do
  logout
  redirect '/'
end






