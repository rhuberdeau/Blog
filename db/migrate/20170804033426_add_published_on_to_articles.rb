class AddPublishedOnToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :published_on, :datetime
  end
end
