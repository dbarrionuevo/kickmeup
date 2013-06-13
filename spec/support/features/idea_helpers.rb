module Features
  module IdeaHelpers
    def current_user_kicked_ideas
      Idea
      .joins(:idea_kickups)
      .where('idea_kickups.user_id = ?',current_user.uid.to_i)
    end    
  end
end