# frozen_string_literal: true

# Injected by the Home Assistant add-on. Shelfarr is reached through HA's ingress
# reverse proxy under a dynamic path, so ActionCable's WebSocket connection arrives
# with an Origin that won't match the app host. The connection is already protected
# by Home Assistant authentication, so request-forgery protection is disabled for
# ActionCable to allow live (Turbo Stream) updates through ingress.
Rails.application.configure do
  config.action_cable.disable_request_forgery_protection = true


  # Rails emits early-hint "Link: </shelfarr/assets/...>; rel=preload" HTTP headers for
  # stylesheets/scripts. The nginx sub_filter only rewrites response *bodies*, not headers,
  # so those preloads keep the bare base path (missing the ingress entry) and 404 under
  # ingress (NS_ERROR_CORRUPTED_CONTENT). Disable them; the body <link>/<script> tags are
  # rewritten correctly and load the assets.
  config.action_view.preload_links_header = false

  # ActionCable is mounted under the base path (e.g. /shelfarr/cable), but the
  # advertised meta-tag URL defaults to the bare "/cable", which the nginx
  # sub_filter (keyed on the base path) would not rewrite. Advertise the based
  # path so it gets rewritten onto the live ingress entry.
  base = ENV.fetch("RAILS_RELATIVE_URL_ROOT", "").chomp("/")
  config.action_cable.url = "#{base}/cable" unless base.empty?
end

# Request-less renders — ActionController::Live streams (e.g. the search results stream),
# jobs, and mailers — render without an HTTP request, so path helpers fall back to an empty
# SCRIPT_NAME and emit URLs WITHOUT the base path (e.g. "/requests/new"), which escape the
# ingress path and 404. Apply the base path as the default script_name so those renders match
# normal in-request URL generation. In-request renders already carry SCRIPT_NAME, so this does
# not double-prefix them.
Rails.application.config.to_prepare do
  base = ENV.fetch("RAILS_RELATIVE_URL_ROOT", "").chomp("/")
  unless base.empty?
    # Controllers/views generate URLs via #url_options, which sets script_name to the
    # request's SCRIPT_NAME. In request-less/streamed renders (ActionController::Live search
    # results) that is empty, so path helpers emit base-less URLs like "/requests/new" that
    # escape the ingress path and 404. (default_url_options does NOT help — url_options
    # overrides script_name.) Force the base path here so every controller/view render — main
    # thread or streaming thread — includes it. In-request renders already carry the same
    # value, so this does not double-prefix.
    ApplicationController.class_eval do
      define_method(:url_options) { super().merge(script_name: base) }
    end
  end
end

Rails.application.config.after_initialize do
  base = ENV.fetch("RAILS_RELATIVE_URL_ROOT", "").chomp("/")
  unless base.empty?
    # Belt-and-suspenders for request-less route-helper calls outside controllers
    # (jobs, mailers) that use Rails.application.routes.url_helpers directly.
    ActionController::Base.default_url_options = { script_name: base }
    Rails.application.routes.default_url_options[:script_name] = base
  end

  # HA ingress terminates TLS and proxies over http on an internal port, so the browser's
  # Origin (https://homeassistant.local) never matches Rails' computed base_url
  # (http://<host>:<ingress_port>). Rails' CSRF origin check then rejects every POST with a
  # 422 (blank page). The authenticity token is still verified and HA authenticates the
  # ingress connection, so disable only the origin comparison. Set on the class directly here
  # (in after_initialize) because the framework overrides config.action_controller.* set
  # earlier during boot.
  ActionController::Base.forgery_protection_origin_check = false
end
