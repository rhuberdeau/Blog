class AddResetPasswordSentAtToUsers < ActiveRecord::Migration
  change_table(:users) do |t|   
      t.datetime :reset_password_sent_at
  end
end
