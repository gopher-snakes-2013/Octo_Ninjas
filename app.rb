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

require_relative 'helpers/session_helper'

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
  include SessionHelper
end

get '/' do
  erb :index
end

post '/signin' do
    set_user
    set_session
    redirect to '/create_survey'
end

get '/register' do
  erb :register
end

post '/register' do
  if user_exists?(params[:username])
    @error = "That username already exists"
    erb :index
  else
    set_user
    set_session
    redirect '/create_survey'
  end
end

get '/create_survey' do
  enforce_login
  my_movie_list
  erb :create_survey
end

post '/create_survey' do
  my_title = params[:movie_title]
  @my_movie = RottenMovie.find(:title => my_title, :limit => 1)
  my_movie_list << Movie.create(:title => @my_movie.title,
    :synopsis => @my_movie.synopsis,
    :runtime => @my_movie.runtime,
    :critics_score => @my_movie.ratings.critics_score,
    :audience_score => @my_movie.ratings.audience_score,
    :pic => @my_movie.posters.original)
  erb :create_survey
end

post '/logout' do
  session.clear
  redirect '/'
end