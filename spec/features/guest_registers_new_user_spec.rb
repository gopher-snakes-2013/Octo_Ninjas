require 'spec_helper'

feature "guest can register new user" do
  context "when valid info is given" do
    let(:new_user) do
      { name: "Taylor", email: "go@away.com", password: "password" }
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