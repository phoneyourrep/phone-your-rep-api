# frozen_string_literal: true

jpartial._state do |state|
  json.self state_url(state.state_code)
  json.extract! state, :state_code, :name, :abbr
end
