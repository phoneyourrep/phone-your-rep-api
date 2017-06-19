# frozen_string_literal: true

json.self office_location_url(office_location.office_id)
json.rep rep_url(office_location.rep.official_id)
json.extract! office_location,
              :active,
              :official_id,
              :level,
              :office_id,
              :bioguide_id,
              :state_leg_id,
              :office_type,
              :distance,
              :building,
              :address,
              :suite,
              :city,
              :state,
              :zip,
              :phone,
              :fax,
              :hours,
              :latitude,
              :longitude,
              :v_card_link,
              :downloads,
              :qr_code_link
