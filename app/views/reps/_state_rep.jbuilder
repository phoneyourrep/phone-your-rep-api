json.source 'https://www.openstates.org/'

json.extract! state_rep,
              :official_full,
              :role,
              :party,
              :url

json.set! 'office_locations', state_rep.sorted_offices_array do |office|
  json.partial! 'office_locations/state_office_location', state_office_location: office if office.phone
end