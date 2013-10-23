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
