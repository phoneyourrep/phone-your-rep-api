# frozen_string_literal: true
json.total_records @districts.count
json.set! '_links' do
  json.self do
    json.href @self
  end
end
json.set! 'districts', @districts do |district|
  json.partial! 'district', district: district
end
