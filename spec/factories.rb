FactoryGirl.define do
  factory :user do
    username     "Rober Huberdeau"
    email        "robert@example.com"
    password     "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :article do
  	title		"this is a test post from factory girl"
  	body		"this is the main content of the test post"
  	summary     "test post summary"
  	user_id     1
  end
end