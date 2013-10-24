$LOAD_PATH.unshift(File.expand_path('.'))

require 'app'
require 'shoulda-matchers'
require 'capybara/rspec'

Capybara.app = Sinatra::Application

RSpec.configure do |config|
  config.before do
    Movie.destroy_all
    Survey.destroy_all
    SurveyMovie.destroy_all
    User.destroy_all
    Vote.destroy_all
  end
end

def register(user)
  visit '/'
  click_on "Register New User"
  fill_in "username", with: user[:name]
  fill_in "email", with: user[:email]
  fill_in "password", with: user[:password]
  click_on "Register"
end

def login
  visit '/'
  fill_in :username, with: "Taylor"
  fill_in :password, with: "password"
  click_on "submit"
end
