require 'spec_helper'

feature "User Profile" do
  context "existing user profile" do
    given!(:idea) { create(:idea) }
    background {
      sign_in
      stub_graph
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

feature "Invite Friends" do
  given!(:friends) do
  [
    {"uid"=>102030, "name"=>"Betty Amfacffefcec", "username"=>"", "pic_square"=>""},
    {"uid"=>102031, "name"=>"Jennifer Sharpewitz", "username"=>"", "pic_square"=>""}
  ]
  end

  context "logged user" do
    background do
      sign_in
      visit root_path
      stub_graph(with_friends: true)
    end

    scenario "can see a list of his frienships" do
      click_link "Invite your friends!"

      expect(page).to have_content("#{friends[0]['name']}")
      expect(page).to have_content("#{friends[1]['name']}")
      expect(page).to have_button("Invite")
    end

    scenario "can invite friends" do
      click_link "Invite your friends!"
      check "recipients_#{friends.first['uid']}"
      click_button "Invite"
    end
  end

  context "guest user" do
    scenario "can't access friends list" do
      expect(page).to_not have_link("Invite your friends!")
    end
  end

end
