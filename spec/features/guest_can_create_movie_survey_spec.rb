require 'spec_helper'

feature "guest can add movies to a movie survey" do
  context "when logged in" do
    let(:new_user) do
      { name: "Taylor", email: "go@away.com", password: "password" }
    end

    scenario "guest can add a movie to a movie survey" do
      login
      expect(page).to have_content("Logged in as: Taylor")      
    end

  end
end