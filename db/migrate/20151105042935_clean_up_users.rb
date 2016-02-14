class CleanUpUsers < ActiveRecord::Migration
  def change
    # Dropping columns that do not belong in the user model
    # This limits the user class to a thin active record backed model
    # It also prevents user objects from becoming God objects
    remove_column :users, :username, :string
    remove_column :users, :bio, :text
    remove_column :users, :approved, :boolean
    # remove_column :users, :admin, :boolean
    remove_column :users, :provider, :string
    remove_column :users, :uid, :string
  end
end
