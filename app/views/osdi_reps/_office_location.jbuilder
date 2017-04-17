# frozen_string_literal: true

json.address_lines do
  json.array! [ol.address, ol.suite].reject(&:blank?)
end
json.locality ol.city
json.region ol.state
json.postal_code ol.zip
json.location do
  json.latitude ol.latitude
  json.longitude ol.longitude
end

json.set! 'pyr:fax', ol.fax
json.set! 'pyr:hours', ol.hours
json.set! 'pyr:phone', ol.phone
json.set! 'pyr:type', ol.office_type
