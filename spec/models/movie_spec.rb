require 'spec_helper'

describe Movie do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:rotten_id) }
    it { should have_many(:surveys).through(:survey_movies) }  
end

