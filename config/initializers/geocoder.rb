# frozen_string_literal: true

require_relative 'geocoder_config'

Geocoder.configure GeocoderConfig::PRODUCTION_OPTIONS if Rails.env.production?
