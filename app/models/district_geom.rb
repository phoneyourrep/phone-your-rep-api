# frozen_string_literal: true

class DistrictGeom < ApplicationRecord
  include Geographic
  belongs_to :district, foreign_key: :full_code, primary_key: :full_code
end
