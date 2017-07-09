# frozen_string_literal: true

return json.error 'Record not found' if rep.blank?

json.self rep_url(rep.official_id)

json.state do
  json.self state_url(rep.state.state_code)
  json.extract! rep.state,
                :state_code,
                :name,
                :abbr
end

if rep.district
  json.district do
    json.self district_url(rep.district.full_code)
    json.extract! rep.district,
                  :full_code,
                  :code,
                  :state_code,
                  :level,
                  :chamber,
                  :name
  end
end

json.extract! rep,
              :active,
              :official_id,
              :level,
              :bioguide_id,
              :state_leg_id,
              :official_full,
              :chamber,
              :role,
              :party,
              :senate_class,
              :last,
              :first,
              :middle,
              :nickname,
              :suffix,
              :contact_form,
              :url,
              :photo,
              :twitter,
              :facebook,
              :youtube,
              :instagram,
              :googleplus,
              :twitter_id,
              :facebook_id,
              :youtube_id,
              :instagram_id

json.set! 'office_locations', rep.active_office_locations do |office_location|
  json.self office_location_url(office_location.office_id)
  json.rep rep_url(office_location.official_id)
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
end
