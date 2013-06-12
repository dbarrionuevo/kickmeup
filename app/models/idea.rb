class Idea < ActiveRecord::Base
	validates :user_id, :title, :description, presence: true
  has_many :kicked_ideas
  attr_accessor :user_kicked

  def to_s
    title
  end

  def kickup
    if user_can_kickup?
      build_kicked_ideas
      increment_kickups_count
    end
    self
  end

  def user_can_kickup?
    user_kicked && !already_kicked_by_user?
  end

  def already_kicked_by_user?
    kicked_ideas.where(user_id: user_kicked.uid).any?
  end

  def build_kicked_ideas
    kicked_ideas.new(user_id: user_kicked.uid)
  end

  def increment_kickups_count
    self.kickups += 1
  end

end
