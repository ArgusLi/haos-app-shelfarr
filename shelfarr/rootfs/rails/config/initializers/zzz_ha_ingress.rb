# frozen_string_literal: true

# Injected by the Home Assistant add-on. Shelfarr is reached through HA's ingress
# reverse proxy under a dynamic path, so ActionCable's WebSocket connection arrives
# with an Origin that won't match the app host. The connection is already protected
# by Home Assistant authentication, so request-forgery protection is disabled for
# ActionCable to allow live (Turbo Stream) updates through ingress.
Rails.application.configure do
  config.action_cable.disable_request_forgery_protection = true

  # ActionCable is mounted under the base path (e.g. /shelfarr/cable), but the
  # advertised meta-tag URL defaults to the bare "/cable", which the nginx
  # sub_filter (keyed on the base path) would not rewrite. Advertise the based
  # path so it gets rewritten onto the live ingress entry.
  base = ENV.fetch("RAILS_RELATIVE_URL_ROOT", "").chomp("/")
  config.action_cable.url = "#{base}/cable" unless base.empty?
end
