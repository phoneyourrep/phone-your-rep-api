# frozen_string_literal: true

require_relative './geocoder_config'

Geocoder.configure GeocoderConfig.production_options if Rails.env.production?
