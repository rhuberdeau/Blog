class CreateSequences < ActiveRecord::Migration[4.2]
  def change
    create_table :sequences do |t|
      t.string :name

      t.timestamps
    end
  end
end
