# A draft is an article with no published_at; one timestamp replaces the
# published boolean plus the published_on date that could disagree with it.
class ReplacePublishedFlagWithPublishedAt < ActiveRecord::Migration[8.1]
  def up
    add_column :articles, :published_at, :datetime
    add_index :articles, :published_at
    execute <<~SQL
      UPDATE articles SET published_at = COALESCE(published_on, created_at) WHERE published
    SQL
    remove_column :articles, :published
    remove_column :articles, :published_on
  end

  def down
    add_column :articles, :published, :boolean, default: false
    add_column :articles, :published_on, :datetime
    execute <<~SQL
      UPDATE articles SET published = TRUE, published_on = published_at WHERE published_at IS NOT NULL
    SQL
    remove_index :articles, :published_at
    remove_column :articles, :published_at
  end
end
