class AddAdminToUsers < ActiveRecord::Migration
  def change
    unless column_exists?(:users, :admin)
      add_column :users, :admin, :boolean, default: false
    end
  end
end
