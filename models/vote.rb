class Vote < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :survey_movie

end
