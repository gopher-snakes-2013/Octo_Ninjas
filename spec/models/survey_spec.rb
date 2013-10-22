require 'spec_helper'

describe Survey do
  it { should validate_presence_of(:survey_url) }
  it { should validate_presence_of(:survey_info) }
  it { should belong_to(:user) }
  it { should have_many(:movies).through(:survey_movies) }  


end
