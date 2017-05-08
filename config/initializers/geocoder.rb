# frozen_string_literal: true

Geocoder.configure GeocoderConfig::PRODUCTION_OPTIONS if Rails.env.production?
