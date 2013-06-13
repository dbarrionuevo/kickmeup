class CreateKickedIdeas < ActiveRecord::Migration
  def change
    create_table :kicked_ideas do |t|
      t.integer :user_id
      t.integer :idea_id

      t.timestamps
    end
    add_index :kicked_ideas, :user_id
    add_index :kicked_ideas, :idea_id
  end
end
