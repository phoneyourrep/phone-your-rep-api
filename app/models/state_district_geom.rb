# frozen_string_literal: true

class StateDistrictGeom < ApplicationRecord
  include Geographic
  include StateDistrictScopes
  belongs_to :state_district, foreign_key: :full_code, primary_key: :full_code
end
