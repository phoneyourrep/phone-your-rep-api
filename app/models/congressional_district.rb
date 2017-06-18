# frozen_string_literal: true

class CongressionalDistrict < District
  is_impressionable counter_cache: true, column_name: :requests
end
