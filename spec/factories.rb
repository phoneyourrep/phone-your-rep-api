# frozen_string_literal: true

require_relative 'geom_spec_helper'

FactoryGirl.define do
  factory :state_district_geom { full_code 'MyString' }

  factory :state_district do
    state_code 'MyString'
    code 'MyString'
    full_code 'MyString'
    name 'MyString'
    chamber 'MyString'
    requests 0
  end

  factory :congressional_rep do
    bioguide_id 'bioguide_id'
    state
  end

  factory :rep do
    bioguide_id 'bioguide_id'
    state
  end

  factory :governor do
    official_full 'Official Full'
    state
  end

  factory :office_location { office_id 'office_id' }
  factory :v_card
  factory :state { state_code 'state_code' }
  factory :congressional_district { state }
  factory :district { state }
  factory :avatar
  factory :impression
  factory :zcta
  factory :zcta_district
  factory :state_geom { geom GeomSpecHelper.nebraska_geometry }
  factory :district_geom { geom GeomSpecHelper.nebraska_geometry }
  factory :congressional_district_geom { geom GeomSpecHelper.nebraska_geometry }
end
