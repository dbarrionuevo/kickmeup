require 'spec_helper'

feature "Share an idea" do
  context "logged user" do
    before{ sign_in }

  	scenario "can share an idea" do
      visit new_idea_path

      fill_in 'idea[title]',       with: "A kickass idea"
      fill_in 'idea[description]', with: "Something to describe my idea properly"
      click_button 'Post my idea'

      expect(page).to have_content 'Idea was successfully created'
      expect(page).to have_content 'Details of A kickass idea'
      expect( current_user.ideas.count ).to eq(1)
    end

    scenario "can't share an idea without valid attributes" do
      visit new_idea_path

      click_button 'Post my idea'

      [:title, :description].each do |attr|
        expect(page).to have_selector("li", text: "#{attr.capitalize} can't be blank")
      end
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
  background { sign_in }
  given!(:idea) { create(:idea) }
  given!(:own_idea) { create(:idea, author: current_user) }

  scenario "user can modify his own idea" do
    visit root_path

    click_link "#{own_idea.title}"
    click_link 'Edit'

    fill_in 'idea[title]', with: "something new"
    click_button 'Post my idea'

    expect(page).to have_content 'Idea was successfully updated'
    expect(own_idea.reload.title).to eql("something new")
  end

  scenario "user can't modify his own idea without valid attributes" do
    visit root_path

    click_link "#{own_idea.title}"
    click_link 'Edit'

    fill_in 'idea[title]', with: ""
    click_button 'Post my idea'

    expect(page).to have_selector("li", text: "Title can't be blank")
    expect(own_idea.reload.title).to_not eql("")
  end

  scenario "user can't modify ideas of another user" do
    visit root_path

    click_link "#{idea.title}"

    expect(page).to_not have_link 'Edit'
  end
end

feature "Listing existing ideas" do
  given!(:idea) { create(:idea) }
	background { visit root_path }

	scenario "guest user can list ideas" do
		expect(page).to have_content "#{idea.title}"
	end

	scenario "guest user can view ideas" do
		click_link "#{idea.title}"
		current_path.should eq idea_path(idea)
	end

  scenario "redirects with invalid idea" do
    visit "/ideas/invalid"

    expect(page).to have_content "Idea not found!"
    expect(current_path).to eq root_path
  end
end

feature "Kicking up an Idea" do
  given!(:idea) { create(:idea) }

  context "logged user" do
    background { sign_in }
    given!(:own_idea) { create(:idea, title: "My own idea", author: current_user) }

    scenario "can kickup an idea only once" do
      click_link "#{idea.title}"
      click_link "kickup this idea!"

      expect(page).to have_content 'Idea was successfully kicked up'
      idea.reload.kickups.should eq 1
      current_user.kicked_ideas.should include(idea)

      click_link "Kick it"

      expect(page).to have_content 'You already kicked this idea'
      idea.reload.kickups.should eq 1
    end

    scenario "can't kickups his own idea" do
      visit root_path
      click_link "#{own_idea.title}"
      click_link "kickup this idea!"

      expect(page).to have_content "Sorry, you can't kickup your own idea"
      expect(idea.kickups).to be_zero
    end

    scenario "can un-kickup a kicked up idea" do
      pending
    end

  end

  scenario "guest user can't kickup idea" do
    expect(page).to_not have_link 'Kick this up!'
  end
end

feature "Destroy an idea" do
  given!(:idea) { create(:idea) }

  context "logged user" do
    background{ sign_in }
    given!(:own_idea) { create(:idea, author: current_user) }

    scenario "can destroy his own an idea" do
      visit root_path
      click_link "#{own_idea.title}"
      click_link "Destroy"

      expect(page).to have_content "Idea was successfully destroyed."
      expect(Idea.count).to eq(1)
    end

    scenario "can't destroy another user idea" do
      click_link "#{idea.title}"

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

feature "Listing kickups details" do
  context "idea kicked by user" do
    given!(:idea) { create(:idea, :with_kickups) }

    scenario "shows user name in the idea details page" do
      visit root_path
      click_link "#{idea.title}"

      expect(page).to have_content("This idea was kicked by 1 user")
      expect(page).to have_content("#{idea.kicked_by.first}")
    end
  end

  context "idea not kicked by user" do
    given!(:idea) { create(:idea) }
    scenario "shows a message in the idea details page" do
      visit root_path
      click_link "#{idea.title}"

      expect(page).to have_content "Be the first to kickup this idea!"
    end
  end
end

feature "Listing kickups count" do
  context "idea kicked by user" do
    given!(:idea) { create(:idea, :with_kickups) }

    scenario "shows kickups count" do
      visit root_path

      expect(page).to have_content "Kicked 1 time"
      expect(idea.kickups).to eq(1)
    end
  end
end
