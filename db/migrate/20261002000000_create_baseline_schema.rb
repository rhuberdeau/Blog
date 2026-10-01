# One baseline in place of the 2010-2018 migrations, which were written for
# Postgres (inet columns, plpgsql) and never ran against anything but a
# Heroku database that no longer exists. This is the schema as of the move
# to SQLite; later migrations change it from here.
class CreateBaselineSchema < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: "", index: { unique: true }
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token, index: { unique: true }
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer :sign_in_count, null: false, default: 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
      t.boolean :admin, default: false
      t.timestamps
    end

    create_table :articles do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.text :summary
      t.text :body
      t.boolean :published, default: false
      t.datetime :published_on
      t.timestamps
    end

    create_table :tags do |t|
      t.string :name, index: { unique: true }
      t.timestamps
    end

    create_table :taggings do |t|
      t.references :article, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.timestamps
      t.index [ :article_id, :tag_id ], unique: true
    end

    create_table :contacts do |t|
      t.string :name
      t.string :email_address
      t.string :phone_number
      t.text :message
      t.timestamps
    end
  end
end
