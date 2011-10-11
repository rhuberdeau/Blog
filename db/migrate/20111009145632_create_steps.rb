class CreateSteps < ActiveRecord::Migration
  def self.up
    create_table :steps do |t|
      t.text :body
      t.integer :position
      t.integer :tutorial_id, :null => false, :options =>
        "CONSTRAINT fk_step_tutorials REFERENCES tutorials(id)"

      t.timestamps
    end
    add_index :steps, :tutorial_id
    add_index :steps, :position
  end

  def self.down
    drop_table :steps
  end
end
