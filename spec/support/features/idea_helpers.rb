module Features
  module IdeaHelpers
    def current_user_kicked_ideas
      Idea
      .joins(:kicked_ideas)
      .where('kicked_ideas.user_id = ?',current_user.uid.to_i)
    end

    def create_idea(idea_attrs={})
      sign_in
      visit new_idea_path
      fill_in 'idea[title]', with: idea_attrs[:title]
      fill_in 'idea[description]', with: idea_attrs[:description]
      click_button 'Post my idea'
    end

    def modify_idea(idea_attrs={})
      sign_in
      visit root_path
      click_link "#{idea.title}"
      click_link 'Edit'
      fill_in 'idea[title]', with: idea_attrs[:title]
      click_button 'Post my idea'
    end    
  end
end