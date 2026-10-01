# Every action requires a signed-in author unless its controller opts out
# with allow_unauthenticated_access (see Authentication).
class ApplicationController < ActionController::Base
  include Authentication
  protect_from_forgery with: :exception

  before_action :redirect_to_canonical_host

  private
    # www and the second domain serve the same site; send everyone to one
    # address so links, feeds and search engines agree on it.
    def redirect_to_canonical_host
      host = Rails.configuration.x.canonical_host
      return if host.nil? || request.host == host

      redirect_to "#{request.protocol}#{host}#{request.fullpath}", status: :moved_permanently, allow_other_host: true
    end
end
