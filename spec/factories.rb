# frozen_string_literal: true

require_relative 'geom_spec_helper'

FactoryGirl.define do
  factory :rep do
    bioguide_id 'bioguide_id'
    state
  end

  factory :state { state_code 'state_code' }
  factory :district
  factory :office_location
  factory :avatar
  factory :impression
  factory :v_card
  factory :zcta
  factory :zcta_district
  factory :state_geom { geom GeomSpecHelper.nebraska_geometry }
  factory :district_geom { geom GeomSpecHelper.nebraska_geometry }
end
