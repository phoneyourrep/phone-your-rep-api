# frozen_string_literal: true
json.self api_beta_office_location_url(office_location.office_id)
json.rep api_beta_rep_url(office_location.rep.bioguide_id)
json.extract! office_location,
              :active,
              :office_id,
              :bioguide_id,
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
