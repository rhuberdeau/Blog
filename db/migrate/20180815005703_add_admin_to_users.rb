class AddAdminToUsers < ActiveRecord::Migration[4.2]
  def change
    unless column_exists?(:users, :admin)
      add_column :users, :admin, :boolean, default: false
    end
  end
end
