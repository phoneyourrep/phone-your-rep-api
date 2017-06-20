# frozen_string_literal: true

class CongressionalDistrictGeom < DistrictGeom
  include LowerChamberByDefault

  belongs_to :district,
             foreign_key: :full_code,
             primary_key: :full_code,
             class_name: 'CongressionalDistrict'
end
