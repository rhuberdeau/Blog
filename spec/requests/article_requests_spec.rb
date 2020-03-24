require 'spec_helper'

RSpec.describe "Article management", :type => :request do
  let (:article) { FactoryBot.create(:article) }

  it 'shows links to the previous and next article' do
    get "/articles/#{article.id}"

    expect(response).to render_template(:show)
    expect(response.body).to include("This is the body of article")
  end
end
