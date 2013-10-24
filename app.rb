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
  enforce_login
  session[:movie_list] = []
  erb :create_survey
end

post '/add_movie' do
	search_title = params[:movie_title]
	@movie_data = RottenMovie.find(:title => search_title, :limit => 1)

	@current_movie = Movie.create(:title => @movie_data.title,
							 								  :synopsis => @movie_data.synopsis, 
							 								  :runtime => @movie_data.runtime, 
							 								  :critics_score => @movie_data.ratings.critics_score, 
							 								  :audience_score => @movie_data.ratings.audience_score, 
							 								  :pic => @movie_data.posters.original )

  session[:movie_list] << @current_movie.title
  @movie_list = session[:movie_list]

	erb :create_survey
end

post '/finish_survey' do
  p "Finished Survey!!!!!!!!!!!!!!!!!!!!!!!!"
  enforce_login
  @movie_list = session[:movie_list]
  p @movie_list

  erb :finish_survey
end

post '/logout' do
  logout
  redirect '/'
end






