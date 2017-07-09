# frozen_string_literal: true

return json.error 'Record not found' if rep.blank?

json.self rep_url(rep.official_id)

json.state do
  json.partial! 'states/state', state: rep.state
end

json.district do
  json.partial! 'districts/district', district: rep.district if rep.district
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

json.set! 'office_locations', rep.active_office_locations do |office|
  json.partial! 'office_locations/office_location', office_location: office
end
