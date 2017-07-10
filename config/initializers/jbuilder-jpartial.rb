# frozen_string_literal: true

module Jbuilder::Jpartial
  jpartial :_state do |state|
    json.self state_url(state.state_code)
    json.extract! state, :state_code, :name, :abbr
  end
end