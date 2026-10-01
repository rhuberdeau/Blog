class AddApprovedToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :approved, :boolean, :options =>
     {:default => 2}
  end

  def self.down
    remove_column :users, :approved
  end
end
