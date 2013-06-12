require 'spec_helper'
def given_idea
  given!(:idea) { Idea.create!(user_id: 123456, title: 'Existing Idea Title', description: 'Existing Idea description') }
end

def given_other_idea
  given!(:other_idea) { Idea.create!(user_id: 1234567, title: 'Other Idea Title', description: 'Existing Idea description') }
end

feature "Share an idea" do
  context "logged user" do
  	scenario "can share an idea" do
      sign_in
      visit new_idea_path

      fill_in 'idea[title]',       with: "A kickass idea"
      fill_in 'idea[description]', with: "Something to describe my idea properly"
      click_button 'Post my idea'

      expect(page).to have_content 'Idea was successfully created'
      expect(page).to have_content 'Details of A kickass idea'
      expect( Idea.where(user_id: current_user.uid) ).to exist
    end

    scenario "can't share an idea without valid attributes" do
      sign_in
      visit new_idea_path

      click_button 'Post my idea'

      expect(page).to have_selector("li", text: "Title can't be blank")
      expect(page).to have_selector("li", text: "Description can't be blank")
      expect(Idea.count).to be_zero
    end
  end

  context "guest user" do
    scenario "can't share a new idea" do
      visit new_idea_path

      expect(page).to have_content 'Please sign in'

      current_path.should eq root_path
    end
  end
end

feature "Modify an idea" do
  given_idea
  given_other_idea

  scenario "user can modify his own idea" do
    sign_in
    visit root_path

    click_link "#{idea.title}"
    click_link 'Edit'

    fill_in 'idea[title]', with: "something new"
    click_button 'Post my idea'

    expect(page).to have_content 'Idea was successfully updated'
    expect(Idea.first.title).to eql("something new")
  end

  scenario "user can't modify his own idea without valid attributes" do
    sign_in
    visit root_path

    click_link "#{idea.title}"
    click_link 'Edit'

    fill_in 'idea[title]', with: ""
    click_button 'Post my idea'

    expect(page).to have_selector("li", text: "Title can't be blank")
    expect(Idea.first.title).to_not eql("")
  end

  scenario "user can't modify ideas of another user" do
    sign_in
    visit root_path

    click_link "#{other_idea.title}"

    expect(page).to_not have_link 'Edit'
  end
end

feature "Listing existing ideas" do
	given_idea
	background { visit root_path }
	
	scenario "guest user can list ideas" do
		expect(page).to have_content "#{idea.title}"
	end

	scenario "guest user can view ideas" do
		click_link "#{idea.title}"
		current_path.should eq idea_path(idea)
	end
end

feature "Kicking up an Idea" do
  given_idea

  scenario "logged user can kickup an idea only once" do
    sign_in
    click_link 'Kick this up!'

    expect(page).to have_content 'Idea was successfully kicked up'
    idea.reload.kickups.should eq 1
    current_user_kicked_ideas.should include(idea)

    click_link 'Kick this up!'

    expect(page).to have_content 'You already kicked this idea'
    idea.reload.kickups.should eq 1
  end

  scenario "guest user can't kickup idea" do
    expect(page).to_not have_link 'Kick this up!'
  end
end

feature "Destroy an idea" do
  given_idea
  given_other_idea

  context "logged user" do
    background{ sign_in }

    scenario "can destroy his own an idea" do
      click_link "#{idea.title}"
      click_link "Destroy"
      
      expect(page).to have_content "Idea was successfully destroyed."    
      expect(Idea.count).to eq(1)
    end

    scenario "can't destroy another user idea" do
      click_link "#{other_idea.title}"

      expect(page).to_not have_link('Delete')
    end
  end

  context "guest user" do
    scenario "can't delete ideas" do
      visit root_path
      click_link "#{idea.title}"

      expect(page).to_not have_link('Destroy')
    end
  end

end