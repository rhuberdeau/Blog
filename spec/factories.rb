FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar123"
    password_confirmation "foobar123"
    admin false
  end

  
  factory :article do
    sequence(:title)  { |n| "Article #{n}" }
    sequence(:summary) { |n| "Summary of article #{n}" }
    sequence(:body) { |n| "This is the body of article #{n}"}   
    published true
    user 
  end

  factory :tutorial do
    sequence(:name) { |n| "Tutorial #{n}"}
    sequence(:summary) { |n| "Summary #{n}"}
  end
end