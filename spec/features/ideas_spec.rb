require 'spec_helper'

feature "Share an idea" do
	include_context 'facebook login'

	scenario "logged user can create a new idea" do
		login
		visit new_idea_path
		fill_in 'idea[title]', with: 'A kick ass idea'
		fill_in 'idea[description]', with: 'Something to describe my idea properly'
		click_button 'Post my idea'

		page.should have_content 'Idea was successfully created'
		page.should have_content 'A kick ass idea'
		Idea.where(user_id: 123456).should exist
	end

	scenario "not logged user can\t create a new idea" do
		visit new_idea_path
		page.should have_content 'Please sign in'
		current_path.should eq root_path
	end

end

feature "Listing existing ideas" do
	given!(:idea) { Idea.create!(user_id: 123456, title: 'Existing Idea Title', description: 'Existing Idea description') }
	background {visit root_path}
	
	scenario "guest user can list ideas" do
		page.should have_content "#{idea.title}"
	end

	scenario "guest user can view ideas" do
		click_link "#{idea.title}"
		current_path.should eq idea_path(idea)
	end
end