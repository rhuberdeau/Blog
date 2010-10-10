class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.integer :article_id, :null => false, :options =>
      "CONSTRAINT fk_tagging_articles REFERENCES articles(id)"
      t.integer :tag_id, :null => false, :options =>
      "CONSTRAINT fk_tagging_tags REFERENCES tags(id)"
      t.timestamps
    end
    add_index :taggings, :article_id
    add_index :taggings, :tag_id
  end

  def self.down
    drop_table :taggings
  end
end
