# frozen_string_literal: true

rendering = JsonRendering.new json, route_prefix: :api_beta

json.total_records @reps.size
json.set! '_links' do
  json.self do
    json.href @self
  end
end
json.set! 'reps' do
  rendering.response :reps, @reps
end
