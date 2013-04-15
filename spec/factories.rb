FactoryGirl.define do
  factory :user do
    sequence(:username)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  
  factory :article do
    sequence(:title)  { |n| "Article #{n}" }
    sequence(:summary) { |n| "Summary of article #{n}" }
    sequence(:body) { |n| "This is the body of article #{n}"}   
    published true
    user 
  end
end