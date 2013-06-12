require 'spec_helper'
def given_idea
  given!(:idea) { Idea.create!(user_id: 123456, title: 'Existing Idea Title', description: 'Existing Idea description') }
end

def given_other_idea
  given!(:other_idea) { Idea.create!(user_id: 1234567, title: 'Other Idea Title', description: 'Existing Idea description') }
end

feature "Share an idea" do
	scenario "logged user can share a new idea" do
    create_idea(title: 'A kickass idea', description: 'something to describe my idea')

    page.should have_content 'Idea was successfully created'
    page.should have_content 'A kickass idea' # o {idea.title} ??
    Idea.where(user_id: current_user.uid).should exist
  end

  scenario "not logged user can\'t share a new idea" do
    visit new_idea_path
    page.should have_content 'Please sign in'
    current_path.should eq root_path
  end

  scenario "logged user can't create an idea without valid attributes" do
    create_idea(title: '', description: '')

    page.should have_content 'errors prohibited this idea from being saved'    
  end
end

feature "Modify an idea" do
  given_idea
  given_other_idea

  scenario "user can modify his own idea" do
    modify_idea(title: 'Another title')

    page.should have_content 'Idea was successfully updated'
  end

  scenario "user can\'t modify his own idea with invalid attributes" do
    modify_idea(title: '')

    page.should have_content 'error prohibited this idea from being saved'
  end

  scenario "user can't modify ideas of another user" do
    sign_in
    visit root_path
    click_link "#{other_idea.title}"
    page.should_not have_link 'Edit'
  end
end

feature "Listing existing ideas" do
	given_idea
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
  given_idea

  scenario "logged user can kickup only once an idea" do
    sign_in
    click_link 'Kick this up!'

    page.should have_content 'Idea was successfully kicked up'
    idea.reload.kickups.should eq 1
    current_user_kicked_ideas.should include(idea)

    click_link 'Kick this up!'

    page.should have_content 'You already kicked this idea'
    idea.reload.kickups.should eq 1
  end

  scenario "guest user can't kickup idea" do
    page.should_not have_link 'Kick this up!'
  end
end

feature "Destroy an idea" do
  given_idea

  scenario "user can destroy his own an idea" do
    sign_in
    visit root_path
    click_link "#{idea.title}"
    click_link "Destroy"
    
    page.should have_content "Idea was successfully destroyed."    
    current_path.should eq root_path
  end
end