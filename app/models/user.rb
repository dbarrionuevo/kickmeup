class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :nickname, use: :slugged

  validates :uid, :name, :email, presence: true
  validates :email, :uid, uniqueness: true

  has_many :idea_kickups
  has_many :kicked_ideas, through: :idea_kickups, source: :idea
  has_many :ideas, inverse_of: :author

  def to_s
    name
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.nickname = auth.info.nickname || auth.extra.username || auth.info.name
      user.email = auth.info.email
      user.provider_image = auth.info.image
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    end
  end

  def author_of?(idea)
    ideas.include?(idea)
  end

  def has_kicked_ideas?
    kicked_ideas.any?
  end

end
