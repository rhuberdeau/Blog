class DropRolesTable < ActiveRecord::Migration[4.2]
  def up
  	drop_table :roles
  end

  def down
  	raise ActiveRecord::IrreversibleMigration
  end
end
