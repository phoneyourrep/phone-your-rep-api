# frozen_string_literal: true

class StateDistrict < ApplicationRecord
  belongs_to :state, foreign_key: :state_code, primary_key: :state_code
  has_many   :state_district_geoms, foreign_key: :full_code, primary_key: :full_code

  is_impressionable counter_cache: true, column_name: :requests
end
