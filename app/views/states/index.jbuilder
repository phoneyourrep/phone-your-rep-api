# frozen_string_literal: true

json.total_records @states.count
json.set! '_links' do
  json.self do
    json.href @self
  end
end

json.partial! 'state'
json.set! 'states', @states do |state|
  json._state state
end

