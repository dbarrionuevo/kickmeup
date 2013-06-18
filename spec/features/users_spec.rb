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

feature "Invite Friends" do
  given!(:friends) do
    [
      { "name" => "Alexander Bond", "username" => "alexbond", "id" => "1252345" },
      { "name" => "James Bond", "username" => "jamesbond", "id" => "1252349" }
    ]
  end

  background do
    sign_in
    graph = Koala::Facebook::API
    graph.should_receive(:new).with(current_user.oauth_token).and_return(Koala::Facebook::API)
    graph.should_receive( :fql_query ).and_return(friends)
  end

  scenario "shows a list of user frienships" do
    visit root_path
    click_link "Invite your friends!"

    expect(page).to have_content("#{friends.first['name']}")
    expect(page).to have_button("Invite")
  end

end
