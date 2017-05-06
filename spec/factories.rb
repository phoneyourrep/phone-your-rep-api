# frozen_string_literal: true

FactoryGirl.module_eval do
  define do
    factory :state
  end

  define do
    factory :district
  end

  define do
    factory :rep do
      bioguide_id   'S000033'
      official_full 'Bernard Sanders'
    end
  end

  define do
    factory :office_location
  end

  define do
    factory :avatar
  end
end
