require 'spec_helper'

describe User do
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:email) }
  it { should have_many(:surveys) }
  it { should validate_uniqueness_of(:email) }
end
