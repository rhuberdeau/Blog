class CreateArticles < ActiveRecord::Migration[4.2]
  def self.up
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.string :cached_slug

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
