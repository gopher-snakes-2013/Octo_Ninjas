require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'
require 'securerandom'

enable :sessions

ActiveRecord::Base.establish_connection(:adapter => 'postgresql')

get '/' do
  "Hello Ninjas!"
end
