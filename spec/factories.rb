FactoryGirl.define do
  factory :user do
    username     "Rober Huberdeau"
    email        "robert@example.com"
    password     "foobar"
    password_confirmation "foobar"
  end
end