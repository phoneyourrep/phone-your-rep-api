# frozen_string_literal: true
json.total_records @states.count
json.set! '_links' do
  json.self do
    json.href @self
  end
end
json.set! 'states', @states do |state|
  json.partial! 'state', state: state
end
