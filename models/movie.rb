class Movie < ActiveRecord::Base
  validates :title, presence: true
  has_many :survey_movies
  has_many :surveys, through: :survey_movies


end
