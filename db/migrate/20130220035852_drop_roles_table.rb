class DropRolesTable < ActiveRecord::Migration
  def up
  	drop_table :roles
  end

  def down
  	raise ActiveRecord::IrreversibleMigration
  end
end
