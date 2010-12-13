class AddApprovedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :approved, :boolean, :options =>
     {:default => 2}
  end

  def self.down
    remove_column :users, :approved
  end
end
