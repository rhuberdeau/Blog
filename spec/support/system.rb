require "socket"

# System specs run against the headless Chromium in the `chrome` compose
# service. Capybara's server binds to every interface, and Chrome reaches it
# at this container's own address.
RSpec.configure do |config|
  config.before(:each, type: :system) do
    Capybara.server_host = "0.0.0.0"
    Capybara.app_host = "http://#{IPSocket.getaddress(Socket.gethostname)}:#{Capybara.server_port}"

    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1000], options: {
      browser: :remote,
      url: ENV.fetch("SELENIUM_URL")
    }
  end
end
