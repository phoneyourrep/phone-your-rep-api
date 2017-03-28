# frozen_string_literal: true
module Api
  module Beta
    def send_index_files(table_name)
      source = "api_beta_#{table_name}"
      super table_name, source: source
    end
  end
end
