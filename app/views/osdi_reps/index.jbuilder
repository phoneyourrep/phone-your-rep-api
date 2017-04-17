# frozen_string_literal: true

json.total_records @reps.count
json.set! '_links' do
  json.self do
    json.href @self
  end
end
json.set! '_embedded' do
  json.set! 'osdi:people', @reps do |rep|
    json.partial! 'rep', rep: rep, prefix: @prefix
  end
end
