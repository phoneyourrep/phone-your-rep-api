# frozen_string_literal: true

require 'rails_helper'

describe OfficeLocation, type: :model do
  let :office do
    create :office_location, address: '220 Henry St', city: 'New York', state: 'NY', zip: '10002'
  end

  let :rep do
    create :rep, official_full: 'Full Name', role: 'Rep'
  end

  it 'knows when it needs_geocoding' do
    office = create :office_location, latitude: nil, longitude: nil

    expect(office.needs_geocoding?).to be(true)
  end

  it 'knows when it doesn\'t need geocoding' do
    office = create :office_location, latitude: 1.0, longitude: 1.0

    expect(office.needs_geocoding?).to be(false)
  end

  it 'geocodes after_validation if needs_geocoding' do
    office = create :office_location, state: 'Vermont', latitude: nil, longitude: nil

    expect(office.needs_geocoding?).to be(false)
  end

  it 'has a v_card_link' do
    office = create :office_location, office_id: 'office_id'

    Rails.env = 'production'

    expect(office.v_card_link).to eq('https://phone-your-rep.herokuapp.com/v_cards/office_id')

    Rails.env = 'test'

    expect(office.v_card_link).to eq('http://localhost:3000/v_cards/office_id')
  end

  it 'has a qr_code_link' do
    office = create :office_location, office_id: 'office-id'
    url    = 'https://s3.amazonaws.com/phone-your-rep-images/office_id.png'

    expect(office.qr_code_link).to eq(url)
  end

  it 'can calculate its distance to a point' do
    office = create :office_location, latitude: 1.0, longitude: 1.0
    office.calculate_distance [2.0, 2.0]

    expect(office.distance).to be_a(Float)
    expect(office.distance).to be > 0.0
  end

  it 'concatenates city, state, and zip' do
    expect(office.city_state_zip).to eq("#{office.city} #{office.state} #{office.zip}")
  end

  it 'concatenates a full_address' do
    expect(office.full_address).to eq("#{office.address}, #{office.city_state_zip}")
  end

  it 'geocodes by full_address' do
    address = Geocoder.address [office.latitude, office.longitude]

    expect(address).to include(office.address)
    expect(address).to include(office.city)
    expect(address).to include(office.state)
    expect(address).to include(office.zip)
  end

  it 'makes a v_card with the right data' do
    office.rep = rep
    v_card = office.make_v_card photo: false

    expect(v_card).to be_a(Vpim::Vcard)
    expect(v_card.to_s).to include('BEGIN:VCARD')
    expect(v_card.address.street).to eq(office.address)
    expect(v_card.org.first).to eq(rep.role)
  end
end
