# frozen_string_literal: true

class StateDistrict < District
  is_impressionable counter_cache: true, column_name: :requests
end
