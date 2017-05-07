# frozen_string_literal: true

require 'rails_helper'

describe VCardBuilder do
  before :all do
    @office = create :office_location,
                     address: 'Address',
                     city: 'City',
                     state: 'State',
                     zip: 'Zip',
                     phone: 'Phone'

    @secondary_office = create :office_location,
                               address: 'Address2',
                               city: 'City2',
                               state: 'State2',
                               zip: 'Zip2',
                               phone: 'Phone2'

    @duplicate_secondary_office = create :office_location,
                                         address: 'Address2',
                                         city: 'City2',
                                         state: 'State2',
                                         zip: 'Zip2',
                                         phone: 'Phone2'

    @avatar = create :avatar, data: 'Data'

    @rep = create :rep,
                  official_full: 'First Last, Suffix',
                  first: 'First',
                  last: 'Last',
                  suffix: 'Suffix',
                  role: 'Rep',
                  contact_form: 'Contact Form',
                  avatar: @avatar,
                  office_locations: [@office, @secondary_office, @duplicate_secondary_office]
  end

  after(:all) { [Rep, OfficeLocation, Avatar].each(&:destroy_all) }

  let :v_card { VCardBuilder.new(@office, @rep).make_v_card(photo: true) }

  it 'makes a v_card when passed an office_location and rep as parameters' do
    expect(v_card).to be_a(Vpim::Vcard)
    expect(v_card.to_s).to include('BEGIN:VCARD')
  end

  it 'has accurate primary address info' do
    v_card_address = v_card.address

    expect(v_card_address.street).to eq(@office.address)
    expect(v_card_address.locality).to eq(@office.city)
    expect(v_card_address.region).to eq(@office.state)
  end

  it 'has accurate primary telephone info' do
    expect(v_card.telephone.to_s).to eq(@office.phone)
  end

  it 'has accurate rep info' do
    v_card_name = v_card.name

    expect(v_card_name.fullname).to eq(@rep.official_full)
    expect(v_card_name.given).to eq(@rep.first)
    expect(v_card_name.family).to eq(@rep.last)
    expect(v_card_name.suffix).to eq(@rep.suffix)
  end

  it 'has accurate URI info' do
    expect(v_card.url.uri).to eq(@rep.contact_form)
  end

  it 'uses the rep#url if rep#contact_form is nil' do
    @rep.contact_form = nil
    @rep.url = 'URL'

    expect(v_card.url.uri).to eq('URL')
  end

  it 'has accurate organization info' do
    expect(v_card.org.first).to eq(@rep.role)
  end

  it 'has accurate photo data' do
    expect(v_card.photos.first).to eq(@rep.avatar.data)
  end

  it 'has accurate secondary address info' do
    v_card_address = v_card.addresses.second

    expect(v_card_address.preferred).to be(false)
    expect(v_card_address.street).to eq(@secondary_office.address)
    expect(v_card_address.locality).to eq(@secondary_office.city)
    expect(v_card_address.region).to eq(@secondary_office.state)
  end

  it 'does not add a phone more than once if there are duplicates' do
    expect(v_card.telephones.count).to eq(2)
  end

  it 'has accurate secondary phone info' do
    v_card_phone = v_card.telephones.second

    expect(v_card_phone.preferred).to be(false)
    expect(v_card_phone.to_s).to eq(@secondary_office.phone)
  end
end
