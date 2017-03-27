# frozen_string_literal: true

json.array! @office_locations do |office|
  json.partial! 'office_location', office_location: office
end
