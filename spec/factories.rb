# frozen_string_literal: true

require_relative 'geom_spec_helper'

FactoryGirl.define do
  factory :state_district do
    state_code 'MyString'
    code 'MyString'
    full_code 'MyString'
    name 'MyString'
  end

  factory :rep do
    bioguide_id 'bioguide_id'
    state
  end

  factory :office_location { office_id 'office_id' }
  factory :v_card
  factory :state { state_code 'state_code' }
  factory :district
  factory :avatar
  factory :impression
  factory :zcta
  factory :zcta_district
  factory :state_geom { geom GeomSpecHelper.nebraska_geometry }
  factory :district_geom { geom GeomSpecHelper.nebraska_geometry }
end
