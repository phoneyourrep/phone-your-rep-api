# frozen_string_literal: true

module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end

    def yaml
      YAML.safe_load(response.body)
    end
  end
end
