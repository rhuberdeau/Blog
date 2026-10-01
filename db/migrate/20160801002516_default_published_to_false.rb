class DefaultPublishedToFalse < ActiveRecord::Migration[4.2]
  def change
    change_column :articles, :published, :boolean, :default => false
  end
end
