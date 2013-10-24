require 'spec_helper'

feature "registered user can add movies to a movie survey" do
  context "when logged in" do
    let(:new_user) do
      { name: "Taylor", email: "go@example.com", password: "password" }
    end

    scenario "registered user can add a movie to a movie survey" do
      register(new_user)
      fill_in "movie_title", with: "primer"
      click_on "add movie"
      expect(page).to have_content("Primer")      
    end

    scenario "registered user can add another movie to a survey" do
      register(new_user)
      fill_in "movie_title", with: "avengers"
      click_on "add movie"
      expect(page).to have_content("Marvel's The Avengers")
      fill_in "movie_title", with: "upstream color"
      click_on "add movie"
      expect(page).to have_content("Upstream Color")
    end

    scenario "registered user can complete a survey" do
      register(new_user)
      fill_in "movie_title", with: "gravity"
      click_on "add movie"
      expect(page).to have_content("Gravity")
      fill_in "movie_title", with: "hobbit unexpected journey"
      click_on "add movie"
      expect(page).to have_content("The Hobbit: An Unexpected Journey")
      fill_in "survey_info", with: "totally awesome survey"
      click_on "finish survey"
      expect(page).to have_content("Great! Here's your survey:")
      expect(page).to have_content("Gravity")
      expect(page).to have_content("The Hobbit: An Unexpected Journey")
      expect(page).to have_content("totally awesome survey")
    end
  end
end