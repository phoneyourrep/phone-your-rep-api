# frozen_string_literal: true

require 'rails_helper'

describe VCardBuilder do
  let :office do
    build_stubbed :office_location,
                  address: 'Address',
                  city: 'City',
                  state: 'State',
                  zip: 'Zip',
                  phone: 'Phone'
  end

  let :rep do
    build_stubbed :rep,
                  official_full: 'First Last, Suffix',
                  first: 'First',
                  last: 'Last',
                  suffix: 'Suffix',
                  role: 'Rep'
  end

  let :v_card { VCardBuilder.new(office, rep).make_v_card(photo: false) }

  it 'makes a v_card when passed an office_location and rep as parameters' do
    expect(v_card).to be_a(Vpim::Vcard)
    expect(v_card.to_s).to include('BEGIN:VCARD')
  end

  it 'has accurate address info' do
    v_card_address = v_card.address

    expect(v_card_address.street).to eq(office.address)
    expect(v_card_address.locality).to eq(office.city)
    expect(v_card_address.region).to eq(office.state)
  end

  it 'has accurate telephone info' do
    expect(v_card.telephone.to_s).to eq(office.phone)
  end

  it 'has accurate rep info' do
    v_card_name = v_card.name

    expect(v_card_name.fullname).to eq(rep.official_full)
    expect(v_card_name.given).to eq(rep.first)
    expect(v_card_name.family).to eq(rep.last)
    expect(v_card_name.suffix).to eq(rep.suffix)
  end

  it 'has accurate organization info' do
    expect(v_card.org.first).to eq(rep.role)
  end
end
