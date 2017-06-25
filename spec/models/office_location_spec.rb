# frozen_string_literal: true

require 'rails_helper'

describe OfficeLocation, type: :model do
  after :all { [OfficeLocation, Rep].each(&:destroy_all) }

  let! :rep do
    create :rep, official_full: 'Full Name', role: 'Rep'
  end

  let! :office do
    create :office_location,
           address: '220 Henry St',
           city: 'New York',
           state: 'NY',
           zip: '10002',
           office_id: 'office_id',
           rep: rep
  end

  it 'belongs_to a rep' do
    expect(office.rep).to eq(rep)
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

  it '#make_v_card makes a v_card with the right data' do
    v_card = office.make_v_card photo: true

    expect(v_card).to be_a(Vpim::Vcard)
    expect(v_card.to_s).to include('BEGIN:VCARD')
    expect(v_card.address.street).to eq(office.address)
    expect(v_card.org.first).to eq(rep.role)
  end

  it '#add_qr_code_img creates a qr_code image from v_card data' do
    dragonfly_test_directory = Rails.root.join('public/system/dragonfly/test')

    expect(office.qr_code).to be(nil)
    office.add_qr_code_img
    office.reload

    expect(office.qr_code).not_to be(nil)
    expect(office.qr_code_name).to eq("#{office.office_id}.png")
    expect(Rails.root.join(dragonfly_test_directory, office.qr_code_uid).exist?).to be(true)

    `rm -rf #{dragonfly_test_directory}`
  end

  context 'when belongs to a StateRep' do
    it '#set_city_state_and_zip parses a full address with commas into separate fields' do
      office = OfficeLocation.new address: '123 Main St., Anytown, NY 10000', rep: StateRep.new
      office.set_city_state_and_zip

      expect(office.city).to eq('Anytown')
      expect(office.state).to eq('NY')
      expect(office.zip).to eq('10000')
      expect(office.address).to eq('123 Main St.')

      office = OfficeLocation.new address: '123 Main St., Anytown,  NY    10000', rep: StateRep.new
      office.set_city_state_and_zip

      expect(office.city).to eq('Anytown')
      expect(office.state).to eq('NY')
      expect(office.zip).to eq('10000')
      expect(office.address).to eq('123 Main St.')
    end

    it '#set_city_state_and_zip parses a full address with line breaks into separate fields' do
      office = OfficeLocation.new address: "123 Main St.\nAnytown\nNY 10000-1234", rep: StateRep.new
      office.set_city_state_and_zip

      expect(office.city).to eq('Anytown')
      expect(office.state).to eq('NY')
      expect(office.zip).to eq('10000-1234')
      expect(office.address).to eq('123 Main St.')
    end

    it 'calls #set_city_state_and_zip before_save only if it\'s rep is a StateRep' do
      rep = StateRep.create(state: State.new, chamber: 'chamber')
      office = OfficeLocation.new address: '123 Main St., Anytown, NY 10000', rep: rep
      office.save

      expect(office.address).to eq('123 Main St.')
      expect(office.city).to eq('Anytown')
      expect(office.state).to eq('NY')
      expect(office.zip).to eq('10000')

      rep = Rep.create
      office = OfficeLocation.new address: "123 Main St.\nAnytown\nNY 10000-1234", rep: rep
      office.save

      expect(office.address).to_not eq('123 Main St.')
      expect(office.city).to_not eq('Anytown')
      expect(office.state).to_not eq('NY')
      expect(office.zip).to_not eq('10000-1234')
    end
  end
end
