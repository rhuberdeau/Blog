class AddPublishedUserIdToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :published, :boolean, :options =>
     {:default => 2}
    add_column :articles, :user_id, :integer, :options =>
    "CONSTRAINT fk_article_users REFERENCES users(id)"
    add_index :articles, :user_id
  end
  
  def self.down
    remove_column :articles, :user_id
    remove_column :articles, :published
  end
end
