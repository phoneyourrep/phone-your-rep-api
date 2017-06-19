# frozen_string_literal: true

json.self district_url(district.full_code)
json.extract! district,
              :full_code,
              :code,
              :state_code,
              :level,
              :chamber,
              :name
