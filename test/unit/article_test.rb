require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  
  test "invalid_with_empty_attributes" do
    article = Article.new
    assert !post.valid?
    assert post.errors.invalid?(:title)
    assert post.errors.invalid?(:body)
    
  end
end
