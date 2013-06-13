class IdeaKickup < ActiveRecord::Base
  belongs_to :idea
  belongs_to :user
  after_save :increment_idea_kickups

  def increment_idea_kickups
    idea.update_attribute(:kickups, idea.kickups+1)
  end

  def user_email
    user.email
  end
end
