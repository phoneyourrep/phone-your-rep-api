# frozen_string_literal: true

module Api
  module Beta
    class RepsController < ::RepsController
      include Api::Beta

      # GET /reps
      def index
        execute_index_with_geo_method :find_reps
      end
    end
  end
end
