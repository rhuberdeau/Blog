# Comments, tutorials/steps, sequences, roles and friendly_id-style slugs were
# removed from the app years ago (no models reference them); their tables and
# columns outlived them. Reversible so an old dump can still be migrated.
class DropUnusedLegacyTables < ActiveRecord::Migration[8.1]
  def change
    drop_table :comments do |t|
      t.text :body, null: false
      t.integer :article_id, null: false
      t.timestamps null: true
      t.integer :user_id
    end

    drop_table :steps do |t|
      t.text :body
      t.integer :position, index: true
      t.integer :tutorial_id, null: false, index: true
      t.timestamps null: true
    end

    drop_table :tutorials do |t|
      t.string :name, index: { unique: true }
      t.text :summary
      t.string :permalink, index: { unique: true }
      t.timestamps null: true
    end

    drop_table :sequences do |t|
      t.string :name
      t.timestamps null: true
    end

    drop_table :roles_users, id: false do |t|
      t.integer :role_id
      t.integer :user_id
    end

    drop_table :slugs do |t|
      t.string :name
      t.integer :sluggable_id, index: true
      t.integer :sequence, default: 1, null: false
      t.string :sluggable_type, limit: 40
      t.string :scope
      t.datetime :created_at
      t.index [ :name, :sluggable_type, :sequence, :scope ], unique: true, name: "index_slugs_on_n_s_s_and_s"
    end

    remove_column :articles, :sequence_id, :integer
    remove_column :articles, :cached_slug, :string
  end
end
