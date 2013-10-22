require 'spec_helper'

describe Vote do
  it { should validate_presence_of(:name) }
  it { should belong_to(:survey_movie) }
end
