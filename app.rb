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

set :database, ENV['DATABASE_URL']



get '/' do
  erb :index
end

post '/signin' do
	
end

get '/register' do
	erb :signup
end

post '/register' do
	redirect '/create_survey'
end

get '/create_survey' do
  erb :create_survey
end

post '/create_survey do'


end









