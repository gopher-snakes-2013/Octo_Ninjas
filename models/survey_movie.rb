class SurveyMovie < ActiveRecord::Base
  belongs_to :surveys
  belongs_to :movies

end
