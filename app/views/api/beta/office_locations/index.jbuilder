# frozen_string_literal: true

rendering = JsonRendering.new json, route_prefix: :api_beta

json.total_records @office_locations.count
json.set! '_links' do
  json.self do
    json.href @self
  end
end
json.set! 'office_locations' do
  rendering.response :office_locations, @office_locations
end
