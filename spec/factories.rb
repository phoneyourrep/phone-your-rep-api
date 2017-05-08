# frozen_string_literal: true

require_relative 'geom_spec_helper'

FactoryGirl.define do
  factory :state
  factory :district
  factory :rep
  factory :office_location
  factory :avatar
  factory :impression
  factory :v_card
  factory :zcta
  factory :zcta_district

  factory :state_geom do
    geom GeomSpecHelper.nebraska_geometry
  end

  factory :district_geom do
    geom GeomSpecHelper.nebraska_geometry
  end
end
