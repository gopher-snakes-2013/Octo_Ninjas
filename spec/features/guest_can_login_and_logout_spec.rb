require 'spec_helper'

feature "user can log in and out" do
  context "when valid info is given" do
    let(:new_user) do
      { name: "Taylor", email: "go@example.com", password: "password" }
    end
    background do
      User.create({ username: "Taylor", email: "go@away.com", password: "password"} )
    end

    scenario "user sees confirmation of login" do
      login(new_user)
      expect(page).to have_content("Logged in as: Taylor")
    end

    scenario "user can log out" do
      login(new_user)
      expect(page).to have_content("Select movies for your survey")
      click_on "logout"
      expect(page).to have_content("Sign in")
    end
  end
end