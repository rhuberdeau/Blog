# This migration comes from blog_engine (originally 20130906164211)
class CreateBlogEngineArticles < ActiveRecord::Migration
  def change
    create_table :blog_engine_articles do |t|
      t.string :title
      t.text :content
      t.boolean :published

      t.timestamps
    end
  end
end
