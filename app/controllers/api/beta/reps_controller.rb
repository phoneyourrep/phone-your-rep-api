# frozen_string_literal: true
module Api
  module Beta
    class RepsController < ::RepsController
      def send_index_files
        respond_to do |format|
          format.html do
            render file: 'api_beta_reps.json', layout: false, content_type: 'application/json'
          end
          format.json { send_file 'api_beta_reps.json', filename: 'reps.json' }
          format.yaml { send_file 'api_beta_reps.yaml', filename: 'reps.yaml' }
        end
      end
    end
  end
end
