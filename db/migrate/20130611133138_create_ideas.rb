class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.integer :user_id
      t.string :title
      t.string :description
      t.string :slug

      t.timestamps
    end
    add_index :ideas, :user_id
    add_index :ideas, :slug, unique: true
  end
end
