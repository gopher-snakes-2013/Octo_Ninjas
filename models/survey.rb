class Survey < ActiveRecord::Base
  belongs_to :user
  has_many :survey_movies
  has_many :movies, through: :survey_movies
end
