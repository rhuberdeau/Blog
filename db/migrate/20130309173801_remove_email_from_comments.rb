class RemoveEmailFromComments < ActiveRecord::Migration
  def up
  	remove_column :comments, :email
  	remove_column :comments, :name
  end

  def down
  end
end
