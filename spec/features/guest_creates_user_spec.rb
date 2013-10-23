require 'spec_helper'

feature 'guest visits main page' do
  scenario 'they see login screen with username and password' do
    visit '/'
    expect(page).to have_content "Welcome to Movie Ninja"
  end
end