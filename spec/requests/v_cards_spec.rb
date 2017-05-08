# frozen_string_literal: true

require 'rails_helper'

describe 'VCards API' do
  before :all do
    [VCard, OfficeLocation, Rep, Impression].each(&:destroy_all)
    @rep = create :rep, official_full: 'Official Full'
    @office = create :office_location, bioguide_id: @rep.bioguide_id, city: 'City'
    @v_card = create :v_card, office_location_id: @office.id, data: 'VCard data'
  end

  after :all { [VCard, OfficeLocation, Rep, Impression].each(&:destroy_all) }

  it 'sends a v_card for an office_location based on office_id' do
    get "/v_cards/#{@office.office_id}"

    expect(response).to be_success
    expect(response.content_type).to eq('text/vcard')
    expect(response.headers['Content-Disposition']).to include('Official Full City.vcf')
    expect(response.body).to eq(@v_card.data)
  end

  it 'sends a v_card by #id if office_location cannot be found by office_id' do
    get "/v_cards/#{@office.id}"

    expect(response).to be_success
    expect(response.content_type).to eq('text/vcard')
    expect(response.headers['Content-Disposition']).to include('Official Full City.vcf')
    expect(response.body).to eq(@v_card.data)
  end

  it 'does not send a v_card if office_location cannot be found' do
    get '/v_cards/invalid'

    expect(response.body).to eq('404 VCard not found')
    expect(response.status).to eq(404)
  end

  it 'records a unique Impression by IP' do
    expect(Impression.count).to eq(0)

    get "/v_cards/#{@office.office_id}"

    expect(Impression.count).to eq(1)

    get "/v_cards/#{@office.office_id}"

    expect(Impression.count).to eq(1)
  end
end
