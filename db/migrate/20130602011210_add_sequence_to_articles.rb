class AddSequenceToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :sequence_id, :integer
  end
end
