class AddBioToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :bio, :text
  end

  def self.down
    remove_column :users, :bio
  end
end
