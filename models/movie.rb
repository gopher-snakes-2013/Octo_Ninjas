class Movie < ActiveRecord::Base
  has_many :survey_movies
  has_many :surveys, through: :survey_movies

end
