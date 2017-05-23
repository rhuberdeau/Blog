class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email_address
      t.string :phone_number
      t.text :message

      t.timestamps null: false
    end
  end
end
