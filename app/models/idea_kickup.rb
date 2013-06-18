class IdeaKickup < ActiveRecord::Base
  belongs_to :idea
  belongs_to :user
  after_save do
    process_idea_kickups(1)
  end

  after_destroy do
    process_idea_kickups(-1)
  end

  def process_idea_kickups(sign)
    idea.update_attribute(:kickups, idea.kickups+sign)
  end
end
