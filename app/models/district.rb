# frozen_string_literal: true

class District < ApplicationRecord
  belongs_to :state, foreign_key: :state_code, primary_key: :state_code
  has_many   :district_geoms, foreign_key: :full_code, primary_key: :full_code
  has_many   :reps
  has_many   :zcta_districts, dependent: :destroy
  has_many   :zctas, through: :zcta_districts

  is_impressionable counter_cache: true, column_name: :requests
end
