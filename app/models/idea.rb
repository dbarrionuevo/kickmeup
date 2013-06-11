class Idea < ActiveRecord::Base
	validates :user_id, :title, :description, presence: true
end
