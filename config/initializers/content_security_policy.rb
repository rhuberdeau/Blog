# A strict Content-Security-Policy. The site serves no third-party scripts,
# styles or fonts and has no inline scripts or styles of its own, so
# everything comes from 'self'. The exceptions are the importmap's inline
# <script> tags and Turbo's progress-bar <style>, which carry a per-request
# nonce (javascript_importmap_tags adds it; Turbo reads it from csp_meta_tag).
#
# Keep it that way: no inline scripts or style="" attributes. Images may come
# from https: so an article can embed a remote picture in Markdown.
Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src     :self
    policy.script_src      :self
    policy.style_src       :self
    policy.img_src         :self, :https, :data
    policy.font_src        :self
    policy.connect_src     :self
    policy.object_src      :none
    policy.base_uri        :self
    policy.form_action     :self
    policy.frame_ancestors :none
  end

  config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }
  config.content_security_policy_nonce_directives = %w[script-src style-src]
end
