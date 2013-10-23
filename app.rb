require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'
require 'securerandom'

require './models/movie'
require './models/survey'
require './models/survey_movie'
require './models/user'
require './models/vote'

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
  @user = current_user
  erb :create_survey
end

post '/create_survey' do


end

post '/logout' do
  session.clear
  redirect '/'
end






