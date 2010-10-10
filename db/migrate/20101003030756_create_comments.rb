class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :name, :null => false
      t.string :email, :null => false
      t.text :body, :null => false
      t.integer :article_id, :null => false, :options =>
      "CONSTRAINT fk_comment_articles REFERENCES articles(id)"

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
