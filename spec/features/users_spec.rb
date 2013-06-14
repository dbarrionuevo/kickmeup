require 'spec_helper'

feature "User Profile" do
  context "logged user" do
    given!(:idea) { create(:idea) }
    background {
      sign_in
      click_link "Kick this up!"
    }

    scenario "can visit his profile" do
      visit "/users/#{current_user.slug}"

      expect(page).to have_content("Your kicked ideas")
      expect(page).to have_content("#{idea.title}")
    end
  end

  context "existing user unauthenticated" do
    given!(:user) { create(:user) }

    scenario "can't visit his profile" do
      visit "/users/#{user.slug}"

      expect(page).to have_content("Please sign in")
      expect(current_path).to eq root_path
    end
  end
end
