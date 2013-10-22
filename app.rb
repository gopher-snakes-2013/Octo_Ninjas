require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'
require 'securerandom'
require 'rottentomatoes'

include RottenTomatoes

Rotten.api_key = 'z9rcfwsnkafcdrwpxhqsaqqy'

enable :sessions

ActiveRecord::Base.establish_connection(:adapter => 'postgresql')

get '/' do
  "Hello Ninjas!"
  @movie = MovieSearcher.find_by_release_name("Avengers")
  @movie.title
  
  @movie = RottenMovie.find(:title => "Avengers", :limit => 1)
  p @movie.synopsis
end
