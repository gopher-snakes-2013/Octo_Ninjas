%w(sinatra sinatra/activerecord bcrypt securerandom rottentomatoes ./models/movie ./models/survey ./models/survey_movie ./models/user ./models/vote).each {|dependency| require dependency}

include RottenTomatoes

Rotten.api_key = 'z9rcfwsnkafcdrwpxhqsaqqy' ## Thanks for your key bro

begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
end

enable :sessions

set :database, ENV['DATABASE_URL'] || "postgres://localhost/ninjadb"

def current_user
  @current_user ||= User.find(session[:user_id]) 
  #What is the the point of loggedin if current user takes the value of User.find?
end

def logged_in?
  session[:user_id]
  #Although this is a truthy value its not a boolean
end

def enforce_login
  redirect '/' unless logged_in? ## unless rather than !if
end

def check_existing_user(username)
  user = User.find_by_username(username)
  if user  
    return user
  else
    return false
  end
end

def add_to_movie_list
  @my_movie_list = []
  @my_movie = RottenMovie.find(:title => my_title, :limit => 1)

  @my_movie_list << Movie.create(:title => @my_movie.title,
                                 :synopsis => @my_movie.synopsis, 
                                 :runtime => @my_movie.runtime, 
                                 :critics_score => @my_movie.ratings.critics_score, 
                                 :audience_score => @my_movie.ratings.audience_score, 
                                 :pic => @my_movie.posters.original
  )
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
	@my_movie_list = []
	
  enforce_login
  @user = current_user
  erb :create_survey
end

post '/create_survey' do
  @user = current_user
	my_title = params[:movie_title]
  add_to_movie_list
	erb :create_survey
end

post '/logout' do
  session.clear
  redirect '/'
end






