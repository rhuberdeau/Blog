FactoryBot.define do
  factory :user do
    sequence(:email_address) { |n| "person_#{n}@example.com" }
    password { "foobar123" }
  end

  factory :article do
    sequence(:title)   { |n| "Article #{n}" }
    sequence(:summary) { |n| "Summary of article #{n}" }
    sequence(:body)    { |n| "This is the body of article #{n}" }
    published { true }
    user
  end
end
