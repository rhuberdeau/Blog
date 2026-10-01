# Devise -> Rails 8 authentication. Devise's encrypted_password is a plain
# bcrypt hash (no pepper was configured), which is exactly what
# has_secure_password stores, so existing passwords keep working.
# There is one user and they are the admin, so the flag goes too.
class ReplaceDeviseColumnsOnUsers < ActiveRecord::Migration[8.1]
  def change
    rename_column :users, :email, :email_address
    rename_column :users, :encrypted_password, :password_digest

    remove_index :users, :reset_password_token, unique: true
    remove_column :users, :reset_password_token, :string
    remove_column :users, :reset_password_sent_at, :datetime
    remove_column :users, :remember_created_at, :datetime
    remove_column :users, :sign_in_count, :integer, null: false, default: 0
    remove_column :users, :current_sign_in_at, :datetime
    remove_column :users, :last_sign_in_at, :datetime
    remove_column :users, :current_sign_in_ip, :string
    remove_column :users, :last_sign_in_ip, :string
    remove_column :users, :admin, :boolean, default: false
  end
end
