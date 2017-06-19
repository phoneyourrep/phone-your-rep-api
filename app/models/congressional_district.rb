# frozen_string_literal: true

class CongressionalDistrict < District
  include LowerChamberByDefault
  is_impressionable counter_cache: true, column_name: :requests
end
