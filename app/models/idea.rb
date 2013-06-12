class Idea < ActiveRecord::Base
	validates :user_id, :title, :description, presence: true
  has_many :kicked_ideas
  attr_accessor :user_kicked

  def kickup
    return if already_kicked_by_user?
    build_kickup_ideas
    self.kickups += 1
  end

  def build_kickup_ideas
    kicked_ideas.new(user_id: user_kicked.uid)
  end

  def already_kicked_by_user?
    kicked_ideas.where(user_id: user_kicked.uid).any?
  end
end
