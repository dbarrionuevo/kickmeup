class AddKickupsToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :kickups, :integer, default: 0
  end
end
