require 'spec_helper'

feature "user can log in and out" do
  context "when valid info is given" do
    background do
      User.create({ username: "Taylor", email: "go@away.com", password: "password"} )
    end
    scenario "they see confirmation of login" do
      visit '/'
      fill_in :username, with: "Taylor"
      fill_in :password, with: "password"
      click_on "submit"
      expect(page).to have_content("Logged in as: Taylor")
    end
  end
end