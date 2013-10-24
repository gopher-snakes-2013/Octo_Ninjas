class Movie < ActiveRecord::Base
  validates :title, :rotten_id, presence: true
  validates :rotten_id, uniqueness: true

  has_many :survey_movies
  has_many :surveys, through: :survey_movies

end
