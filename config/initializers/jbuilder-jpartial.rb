# frozen_string_literal: true

Jbuilder::Jpartial.configure do
  jpartial :_district do |district|
    json.self district_url(district.full_code)
    json.extract! district, :full_code, :code, :state_code, :level, :chamber, :name
  end
end