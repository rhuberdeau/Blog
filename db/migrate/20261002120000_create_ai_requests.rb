# One row per AI assistant request (review, research, outline, metadata):
# what was asked, what came back, and what it cost. Research and outlines
# are kept as notes the author can come back to.
class CreateAiRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :ai_requests do |t|
      t.string :kind, null: false
      t.references :article, foreign_key: { on_delete: :nullify }
      t.string :status, null: false, default: "queued"
      t.json :input, null: false, default: {}
      t.json :result
      t.text :error
      t.string :model
      t.integer :input_tokens, null: false, default: 0
      t.integer :output_tokens, null: false, default: 0
      t.integer :web_searches, null: false, default: 0
      t.decimal :cost_usd, precision: 10, scale: 4, null: false, default: 0
      t.timestamps
      t.index :created_at
    end
  end
end
