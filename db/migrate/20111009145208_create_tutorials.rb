class CreateTutorials < ActiveRecord::Migration
  def self.up
    create_table :tutorials do |t|
      t.string :name
      t.text :summary
      t.string :permalink

      t.timestamps
    end
    add_index :tutorials, :name, :unique => true
    add_index :tutorials, :permalink, :unique => true
  end

  def self.down
    drop_table :tutorials
  end
end
