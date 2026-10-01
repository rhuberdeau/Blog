class AddSummaryToArticles < ActiveRecord::Migration[4.2]
  def self.up
    add_column :articles, :summary, :text
  end

  def self.down
    remove_column :articles, :summary
  end
end
