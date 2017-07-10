# frozen_string_literal: true

module Jbuilder::Jpartial
  jpartial :_state do |state|
    json.self state_url(state.state_code)
    json.extract! state, :state_code, :name, :abbr
  end

  jpartial :_district do |district|
    json.self district_url(district.full_code)
    json.extract! district, :full_code, :code, :state_code, :level, :chamber, :name
  end
end