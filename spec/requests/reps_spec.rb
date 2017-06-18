# frozen_string_literal: true

require 'rails_helper'

describe 'Reps API' do
  before(:all) { [Rep, District, State, DistrictGeom].each(&:destroy_all) }

  after(:all) { [Rep, District, State, DistrictGeom].each(&:destroy_all) }

  it 'sends a list of cached reps in JSON format' do
    cache = File.open(Rails.root.join('index_files/reps.json')) do |file|
      JSON.parse(file.read)
    end

    get '/reps'

    expect(response).to be_success
    expect(json).to eq(cache)

    get '/reps.json'

    expect(response).to be_success
    expect(json).to eq(cache)
  end

  it 'sends a list of cached reps in YAML format' do
    cache = File.open(Rails.root.join('index_files/reps.yaml')) do |file|
      YAML.safe_load(file.read)
    end

    get '/reps.yaml'

    expect(response).to be_success
    expect(yaml).to eq(cache)
  end

  it 'sends a list of generated reps' do
    create_list(:rep, 10)
    get '/reps?generate=true'

    expect(response).to be_success
    expect(json.length).to eq(10)
    json.each { |json_rep| expect(json_rep['bioguide_id']).to eq('bioguide_id') }
  end

  it 'retrieves a specific rep' do
    rep = create :rep
    get "/reps/#{rep.bioguide_id}"

    expect(response).to be_success
    expect(json['bioguide_id']).to eq(rep.bioguide_id)
  end

  context 'searching by location' do
    let! :state { create :state }
    let! :congressional_district { create :congressional_district, full_code: '1', state: state }
    let! :congressional_district_geom { create :congressional_district_geom, full_code: '1' }
    let! :rep_one { create :rep, bioguide_id: 'rep_one', district: congressional_district }
    let! :rep_two { create :rep, bioguide_id: 'rep_two', state: state }
    let! :rep_three { create :rep }

    it 'with coordinates retrieves the right set of reps' do
      get '/reps?lat=41.0&long=-100.0'

      expect(response).to be_success
      expect(json.length).to eq(2)

      bioguide_ids = json.map { |rep| rep['bioguide_id'] }

      expect(bioguide_ids).to include(rep_one.bioguide_id)
      expect(bioguide_ids).to include(rep_two.bioguide_id)
      expect(bioguide_ids).not_to include(rep_three.bioguide_id)
    end

    it 'with an address retrieves the right set of reps' do
      get '/reps?address=Cozad%20Nebraska'

      expect(response).to be_success
      expect(json.length).to eq(2)

      bioguide_ids = json.map { |rep| rep['bioguide_id'] }

      expect(bioguide_ids).to include(rep_one.bioguide_id)
      expect(bioguide_ids).to include(rep_two.bioguide_id)
      expect(bioguide_ids).not_to include(rep_three.bioguide_id)
    end

    it 'returns an empty array when lat and long params are given but are empty' do
      get '/reps?lat=&long='

      expect(response).to be_success
      expect(json.length).to eq(0)
      expect(json).to eq([])
    end

    it 'returns an empty array when address param is given but is empty' do
      get '/reps?address='

      expect(response).to be_success
      expect(json.length).to eq(0)
      expect(json).to eq([])
    end

    it 'returns an empty array when location params are not null but a district cannot be found' do
      get '/reps?lat=0.0&long=0.0'

      expect(response).to be_success
      expect(json.length).to eq(0)
      expect(json).to eq([])
    end

    it 'leaves an impression' do
      get '/reps?lat=41.0&long=-100.0'

      expect(Impression.count).to eq(1)
      expect(Impression.last.impressionable_type).to eq('District')
      expect(Impression.last.impressionable_id).to eq(congressional_district.id)
    end

    it 'only leaves unique impressions by IP' do
      expect(Impression.count).to eq(0)

      get '/reps?lat=41.0&long=-100.0'

      expect(Impression.count).to eq(1)

      get '/reps?lat=41.0&long=-100.0'

      expect(Impression.count).to eq(1)
    end
  end

  context 'searching by scope' do
    before(:all) do
      @new_york    = create :state, name: 'New York', abbr: 'NY', state_code: '1'
      @california  = create :state, name: 'California', abbr: 'CA', state_code: '2'
      @ny_one      = create :congressional_district, code: '1', full_code: '11', state: @new_york
      @ny_two      = create :congressional_district, code: '2', full_code: '12', state: @new_york
      @ca_one      = create :congressional_district, code: '1', full_code: '21', state: @california
      @ca_two      = create :congressional_district, code: '2', full_code: '22', state: @california
      @ny_one_geom = create :congressional_district_geom, full_code: '11'

      2.times do
        create :rep,
               party: 'Republican',
               state: @new_york,
               role: 'United States Senator'
        create :rep,
               party: 'Democrat',
               state: @new_york,
               district: @ny_one,
               role: 'United States Representative'
        create :rep,
               party: 'Democrat',
               state: @new_york,
               district: @ny_two,
               role: 'United States Representative'
        create :rep,
               party: 'Democrat',
               state: @california,
               role: 'United States Senator'
        create :rep,
               party: 'Republican',
               state: @california,
               district: @ca_one,
               role: 'United States Representative'
        create :rep,
               party: 'Republican',
               state: @california,
               district: @ca_two,
               role: 'United States Representative'
      end

      create :rep, party: 'Independent'
    end

    it 'returns all reps whose district code matches the district param' do
      get '/reps?district=1'

      expect(response).to be_success
      expect(json.length).to eq(4)
      expect(json.all? { |rep| rep['district']['code'] == '1' }).to be(true)
    end

    it 'returns all reps whose district full_code matches the district param' do
      get '/reps?district=21'

      expect(response).to be_success
      expect(json.length).to eq(2)
      expect(json.all? { |rep| rep['district']['full_code'] == '21' }).to be(true)
    end

    it 'returns nothing if the district can\'t be found' do
      get '/reps?district=unknown'

      expect(response).to be_success
      expect(json.length).to eq(0)
    end

    it 'returns all reps whose state abbr matches the state param' do
      get '/reps?state=NY'

      expect(response).to be_success
      expect(json.length).to eq(6)
      expect(json.all? { |rep| rep['state']['abbr'] == 'NY' }).to be(true)

      first_response_body = response.body

      get '/reps?state=ny'

      expect(response.body).to eq(first_response_body)
    end

    it 'returns all reps whose state abbr matches the state param' do
      get '/reps?state=california'

      expect(response).to be_success
      expect(json.length).to eq(6)
      expect(json.all? { |rep| rep['state']['name'] == 'California' }).to be(true)

      first_response_body = response.body

      get '/reps?state=CalIfornIa'

      expect(response.body).to eq(first_response_body)
    end

    it 'returns all reps whose party affiliation matches the party param' do
      get '/reps?party=republican'

      expect(response).to be_success
      expect(json.length).to eq(6)
      expect(json.all? { |rep| rep['party'] == 'Republican' }).to be(true)

      get '/reps?party=democrat'

      expect(response).to be_success
      expect(json.length).to eq(6)
      expect(json.all? { |rep| rep['party'] == 'Democrat' }).to be(true)
    end

    it 'can fetch reps by party with a boolean attribute' do
      get '/reps?republican=true'

      expect(response).to be_success
      expect(json.length).to eq(6)
      expect(json.all? { |rep| rep['party'] == 'Republican' }).to be(true)

      get '/reps?democrat=true'

      expect(response).to be_success
      expect(json.length).to eq(6)
      expect(json.all? { |rep| rep['party'] == 'Democrat' }).to be(true)

      get '/reps?independent=true'

      expect(response).to be_success
      expect(json.length).to eq(1)
      expect(json.first['party']).to eq('Independent')
    end

    it 'returns the reps whose chamber matches the chamber param' do
      get '/reps?chamber=lower'

      expect(response).to be_success
      expect(json.length).to eq(8)
      expect(json.all? { |rep| rep['role'] == 'United States Representative' }).to be(true)

      get '/reps?chamber=upper'

      expect(response).to be_success
      expect(json.length).to eq(4)
      expect(json.all? { |rep| rep['role'] == 'United States Senator' }).to be(true)
    end

    it 'returns nothing if the chamber can\'t be found' do
      get '/reps?chamber=unknown'

      expect(response).to be_success
      expect(json.length).to eq(0)
    end

    it 'can combine scopes' do
      get '/reps?state=ca&district=1'

      expect(response).to be_success
      expect(json.length).to be(2)
      expect(json.all? { |rep| rep['state']['name'] == 'California' }).to be(true)
      expect(json.all? { |rep| rep['district']['code'] == '1' }).to be(true)

      get '/reps?chamber=lower&party=democrat'

      expect(response).to be_success
      expect(json.length).to be(4)
      expect(json.all? { |rep| rep['role'] == 'United States Representative' }).to be(true)
      expect(json.all? { |rep| rep['party'] == 'Democrat' }).to be(true)
    end

    it 'can combine location lookups and scopes' do
      get '/reps?lat=41.0&long=-100.0'

      expect(response).to be_success
      expect(json.length).to be(4)
      expect(json.all? { |rep| rep['state']['state_code'] == '1' }).to be(true)
      expect(json.select { |rep| rep['district'] && rep['district']['code'] == '1' }.size).to be(2)

      get '/reps?lat=41.0&long=-100.0&party=republican'

      expect(response).to be_success
      expect(json.length).to be(2)
      expect(json.all? { |rep| rep['state']['state_code'] == '1' }).to be(true)
      expect(json.all? { |rep| rep['party'] == 'Republican' }).to be(true)
      expect(json.none? { |rep| rep['district'] }).to be(true)
    end
  end
end
