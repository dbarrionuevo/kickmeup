require 'spec_helper'
def create_idea(user_id = 123456)
  given!(:idea) { Idea.create!(user_id: user_id, title: 'Existing Idea Title', description: 'Existing Idea description') }
end

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
		Idea.where(user_id: current_user.uid).should exist
	end

	scenario "not logged user can\'t create a new idea" do
		visit new_idea_path
		page.should have_content 'Please sign in'
		current_path.should eq root_path
	end
end

feature "Modify an idea" do
  include_context 'facebook login'
  create_idea(123456)
  scenario "user can modify his own idea" do
    login
    visit root_path
    click_link 'Edit'
  end
end

feature "Listing existing ideas" do
	create_idea
	background {visit root_path}
	
	scenario "guest user can list ideas" do
		page.should have_content "#{idea.title}"
	end

	scenario "guest user can view ideas" do
		click_link "#{idea.title}"
		current_path.should eq idea_path(idea)
	end
end

feature "Kicking up an Idea" do
  include_context 'facebook login'  
  create_idea

  scenario "logged user kickup idea" do
    login
    click_link 'Kick this up!'

    page.should have_content 'Idea was successfully kicked up'
    idea.reload.kickups.should eq 1

    click_link 'Kick this up!'
    idea.reload.kickups.should eq 1
    KickedIdea.where(user_id: current_user.uid, idea_id: idea.id).should exist
  end

  scenario "guest user can\t kickup idea" do
    page.should_not have_link 'Kick this up!'
  end
end 