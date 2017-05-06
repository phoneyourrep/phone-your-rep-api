# frozen_string_literal: true

require 'rails_helper'

describe OfficeLocation, type: :model do
  it 'knows when it needs_geocoding' do
    office = create :office_location, latitude: nil, longitude: nil

    expect(office.needs_geocoding?).to be(true)
  end

  it 'knows when it doesn\'t need geocoding' do
    office = create :office_location, latitude: 1.0, longitude: 1.0

    expect(office.needs_geocoding?).to be(false)
  end

  it 'geocodes after_validation if needs_geocoding' do
    office = create :office_location, state: 'Vermont'

    expect(office.needs_geocoding?).to be(false)
  end
end
