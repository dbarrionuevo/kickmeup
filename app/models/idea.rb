class Idea < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  validates :user_id, :title, :description, presence: true
  validates :title, uniqueness: true

  has_many :idea_kickups
  has_many :kicked_by, through: :idea_kickups, source: :user
  belongs_to :author, class_name: 'User', foreign_key: :user_id, inverse_of: :ideas

  attr_accessor :user_kicked

  def to_s
    title
  end

  def kickup
    build_idea_kickups if user_can_kickup?
    self
  end

  def user_can_kickup?
    user_kicked && !already_kicked_by_user?
  end

  def already_kicked_by_user?
    kicked_by.include?(user_kicked)
  end

  def build_idea_kickups
    idea_kickups.new(user_id: user_kicked.id)
  end

end
