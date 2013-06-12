module Features
  module IdeaHelpers
    def current_user_kicked_ideas
      Idea
      .joins(:kicked_ideas)
      .where('kicked_ideas.user_id = ?',current_user.uid.to_i)
    end    
  end
end