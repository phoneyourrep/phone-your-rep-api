# frozen_string_literal: true

json.self api_beta_district_url(district.full_code)
json.extract! district,
              :full_code,
              :code,
              :state_code,
              :chamber,
              :name,
              :type
