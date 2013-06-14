require 'spec_helper'

feature "User Profile" do
  context "existing user profile" do
    given!(:idea) { create(:idea) }
    background {
      sign_in
      click_link "Kick this up!"
    }

    scenario "shows kicked ideas" do
      visit "/users/#{current_user.slug}"

      expect(page).to have_content("Kicked ideas")
      expect(page).to have_content("#{idea.title}")
    end
  end

  context "invalid user profile" do
    scenario "redirect to root path" do
      visit "/users/invalid"

      expect(page).to have_content "Invalid User"
      expect(current_path). to eq root_path
    end
  end
end