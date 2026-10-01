class RemoveEmailFromComments < ActiveRecord::Migration[4.2]
  def up
  	remove_column :comments, :email
  	remove_column :comments, :name
  end

  def down
  end
end
