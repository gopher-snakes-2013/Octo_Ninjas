require 'spec_helper'

feature "guest can register new user" do
  def register(user)
    visit '/'
    click_on "Register New User"
    fill_in "username", with: user[:name]
    fill_in "email", with: user[:email]
    fill_in "password", with: user[:password]
    click_on "Register"
  end

  context "when valid info is given" do
    let(:new_user) do
      { name: "Taylor", email: "go@example.com", password: "password" }
    end
    scenario "they see confirmation of login" do
      register(new_user)
      expect(page).to have_content("Logged in as: Taylor")
    end
    scenario "they are redirected to create survey page" do
      register(new_user)
      expect(page).to have_content("Select movies for your survey")
    end

  end
end