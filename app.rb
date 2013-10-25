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
require './helpers/movie_helper.rb'

begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
end

include RottenTomatoes

Rotten.api_key = ENV['ROTTEN_API_KEY']

helpers do
  include SessionHelper
  include MovieHelper
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

	unless @movie_data.empty?
    @current_movie = Movie.find_or_create_by(rotten_id: @movie_data.id) do |m|
                                     m.title = @movie_data.title
							 								       m.synopsis = @movie_data.synopsis
							 								       m.runtime = @movie_data.runtime
							 								       m.critics_score = @movie_data.ratings.critics_score
							 								       m.audience_score = @movie_data.ratings.audience_score
							 								       m.pic = @movie_data.posters.original
                                  end

    add_to_session(@current_movie.id)
  end
  @movie_list = current_movie_list
	erb :"partials/_movie_template", :layout => false
end

post '/finish_survey' do
  enforce_login
  redirect to '/create_survey' if current_movie_list.empty?
  survey_url = SecureRandom.urlsafe_base64
  @survey = Survey.create(user_id: session[:user_id],
                survey_info: params[:survey_info],
                survey_url: survey_url)
  @survey.movies = current_movie_list
  @survey.save
  
  erb :finish_survey
end

get '/surveys/:survey_url' do
  @survey = Survey.find_by survey_url: params[:survey_url]
  if @survey
    erb :survey
  else
    redirect '/'  
  end
end

post '/logout' do
  logout
  redirect '/'
end