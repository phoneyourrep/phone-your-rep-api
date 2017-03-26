# frozen_string_literal: true
module Api
  module Beta
    class OfficeLocationsController < ::OfficeLocationsController
      def send_index_files
        respond_to do |format|
          format.html do
            render file: 'api_beta_office_locations.json',
                   layout: false,
                   content_type: 'application/json'
          end
          format.json do
            send_file 'api_beta_office_locations.json', filename: 'office_locations.json'
          end
          format.yaml do
            send_file 'api_beta_office_locations.yaml', filename: 'office_locations.yaml'
          end
        end
      end
    end
  end
end
