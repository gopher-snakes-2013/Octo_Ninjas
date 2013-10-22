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
  "Hello Ninjas!"
end
