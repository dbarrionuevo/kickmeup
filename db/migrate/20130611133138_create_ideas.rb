class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.integer :user_id
      t.string :title
      t.string :description

      t.timestamps
    end
    add_index :ideas, :user_id
  end
end
