class AddResetPasswordSentAtToUsers < ActiveRecord::Migration[4.2]
  change_table(:users) do |t|   
      # t.datetime :reset_password_sent_at
  end
end
