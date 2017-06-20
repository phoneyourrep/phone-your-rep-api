# frozen_string_literal: true

module Api
  module Beta
    class RepsController < ::RepsController
      include Api::Beta

      # GET /reps
      def index
        if geo_params.keys.any?
          geo = GeoLookup.new(geo_params.to_h.symbolize_keys)
          @district = geo.congressional_district
          @reps     = apply_scopes(geo.find_reps).each do |rep|
            rep.sort_offices(geo.coordinates.latlon)
          end
        elsif scopes_present?
          @reps = apply_scopes(Rep).active.order(:bioguide_id)
        else
          send_index_files :reps
        end
      end
    end
  end
end
