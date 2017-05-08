# frozen_string_literal: true

module GeocoderConfig
  def self.production_options
    {
      # Geocoding options
      timeout: 5,                      # geocoding service timeout (secs)
      lookup: :google,                 # name of geocoding service (symbol)
      language: :en,                   # ISO-639 language code
      use_https: true,                 # use HTTPS for lookup requests? (if supported)
      api_key: ENV['GOOGLE_API_KEY']   # API key for geocoding service
      # http_proxy: nil,               # HTTP proxy server (user:pass@host:port)
      # https_proxy: nil,              # HTTPS proxy server (user:pass@host:port)
      # cache: nil,                    # cache object (must respond to #[], #[]=, and #keys)
      # cache_prefix: 'geocoder:',     # prefix (string) to use for all cache keys

      # Exceptions that should not be rescued by default
      # (if you want to implement custom error handling);
      # supports SocketError and Timeout::Error
      # always_raise: [],

      # Calculation options
      # units: :mi,                    # :km for kilometers or :mi for miles
      # distances: :linear             # :spherical or :linear
    }
  end
end
