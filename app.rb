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

get '/' do
  erb :index
end

post '/signin' do
  @user = User.authenticate(params[:username], params[:password])
  if @user
    make_active(@user)
    redirect '/create_survey'
  else
    redirect '/'
  end
end

get '/register' do
	erb :register
end

post '/register' do
  @user = User.create( {username: params[:username], email: params[:email], password: params[:password]} )
  if @user
    make_active(@user)
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
	@movie_data = RottenMovie.find(:title => my_title, :limit => 1)

	@my_movie_list << Movie.create(:title => @movie_data.title,
							 									 :synopsis => @movie_data.synopsis, 
							 									 :runtime => @movie_data.runtime, 
							 									 :critics_score => @movie_data.ratings.critics_score, 
							 									 :audience_score => @movie_data.ratings.audience_score, 
							 									 :pic => @movie_data.posters.original
	)
	erb :create_survey
end

post '/logout' do
  logout
  redirect '/'
end






