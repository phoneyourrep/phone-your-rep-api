# frozen_string_literal: true

class StateDistrict < District
  include StateDistrictScopes

  is_impressionable counter_cache: true, column_name: :requests
end