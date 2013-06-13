class ChangeNameToTableKickedIdeas < ActiveRecord::Migration
  def self.up
    rename_table :kicked_ideas, :idea_kickups
  end

  def self.down
    rename_table :idea_kickups, :kicked_ideas
  end
end
