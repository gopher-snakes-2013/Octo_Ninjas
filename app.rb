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
require './helpers/sessions_helpers'

include RottenTomatoes

Rotten.api_key = 'z9rcfwsnkafcdrwpxhqsaqqy'

begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
end

enable :sessions

LOCAL_DATABASE_URL = "postgres://localhost/ninjadb"

set :database, ENV['DATABASE_URL'] || LOCAL_DATABASE_URL

get '/' do
  current_user
  erb :index
end

post '/signin' do
  @user = User.authenticate(params[:username], params[:password])
  unless @user.nil?
    set_active(@user)
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
  unless user_exists?(params[:username])
    @user = User.create({username: params[:username], email: params[:email], password: params[:password]})
    set_active(@user)
    redirect '/create_survey'
  else
    @error = "That username already exists"
    erb :index
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

helpers do
  include SessionsHelpers
end

