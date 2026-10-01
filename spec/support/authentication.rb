module AuthenticationHelpers
  # Signs in through the real sessions endpoint, so specs exercise the same
  # cookie and session row a browser gets.
  def sign_in_as(user, password: "foobar123")
    post session_path, params: { email_address: user.email_address, password: password }
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :request
end
