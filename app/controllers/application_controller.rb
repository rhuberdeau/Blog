# Every action requires a signed-in author unless its controller opts out
# with allow_unauthenticated_access (see Authentication).
class ApplicationController < ActionController::Base
  include Authentication
  protect_from_forgery with: :exception
end
