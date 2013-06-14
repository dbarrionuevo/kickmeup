class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :nickname
      t.string :email
      t.string :provider_image
      t.string :oauth_token
      t.datetime :oauth_expires_at
      t.string :slug

      t.timestamps
    end
    add_index :users, :slug, unique: true
  end
end
