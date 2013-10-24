class Survey < ActiveRecord::Base
  validates :survey_url, :survey_info, presence: true
  validates :survey_url, uniqueness: true

  belongs_to :user
  has_many :survey_movies
  has_many :movies, through: :survey_movies
end
