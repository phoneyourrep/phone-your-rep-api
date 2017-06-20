# frozen_string_literal: true

class CongressionalDistrict < District
  include LowerChamberByDefault

  has_many :reps, foreign_key: :district_id, class_name: 'CongressionalRep'
  has_many :district_geoms,
           foreign_key: :full_code,
           primary_key: :full_code,
           class_name: 'CongressionalDistrictGeom'

  is_impressionable counter_cache: true, column_name: :requests
end
