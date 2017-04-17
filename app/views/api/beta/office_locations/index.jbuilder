# frozen_string_literal: true

json.total_records @office_locations.count
json.set! '_links' do
  json.self do
    json.href @self
  end
end
json.set! 'office_locations', @office_locations do |office|
  json.partial! 'office_location', office_location: office
end
