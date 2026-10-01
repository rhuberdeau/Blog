# The contact form is gone (it emailed through Gmail SMTP with no spam
# protection); the About page links to email instead.
class DropContacts < ActiveRecord::Migration[8.1]
  def change
    drop_table :contacts do |t|
      t.string :name
      t.string :email_address
      t.string :phone_number
      t.text :message
      t.timestamps
    end
  end
end
