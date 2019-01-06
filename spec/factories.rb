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
    first 'First'
    last 'Last'
    state
  end

  factory :office_location do
    office_id 'office_id'
    rep
  end

  factory :state do
    state_code 'state_code'
    abbr 'ABBR'
  end

  factory :congressional_district { state }
  factory :district { state }
  factory :impression
  factory :zcta
  factory :zcta_district
  factory :state_geom { geom GeomSpecHelper.nebraska_geometry }
  factory :district_geom { geom GeomSpecHelper.nebraska_geometry }
  factory :congressional_district_geom { geom GeomSpecHelper.nebraska_geometry }
end
