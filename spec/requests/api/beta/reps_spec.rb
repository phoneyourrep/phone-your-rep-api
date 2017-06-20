# frozen_string_literal: true

require 'rails_helper'

describe 'Reps Beta API' do
  it 'sends a list of cached reps in JSON format' do
    cache = File.open(Rails.root.join('index_files/api_beta_reps.json')) do |file|
      JSON.parse(file.read)
    end

    get '/api/beta/reps'

    expect(response).to be_success
    expect(json).to eq(cache)

    get '/api/beta/reps.json'

    expect(response).to be_success
    expect(json).to eq(cache)
  end

  it 'sends a list of cached reps in YAML format' do
    cache = File.open(Rails.root.join('index_files/api_beta_reps.yaml')) do |file|
      YAML.safe_load(file.read)
    end

    get '/api/beta/reps.yaml'

    expect(response).to be_success
    expect(yaml).to eq(cache)
  end

  it 'sends a list of generated reps' do
    create_list(:congressional_rep, 10)
    get '/api/beta/reps?generate=true'

    expect(response).to be_success
    expect(json['total_records']).to eq(10)
    expect(json['reps'].length).to eq(10)
    json['reps'].each { |json_rep| expect(json_rep['bioguide_id']).to eq('bioguide_id') }
  end

  it 'retrieves a specific rep' do
    rep = create :congressional_rep
    get "/api/beta/reps/#{rep.bioguide_id}"

    expect(response).to be_success
    expect(json['bioguide_id']).to eq(rep.bioguide_id)
  end

  context 'searching by location' do
    let! :state { create :state }
    let! :congressional_district { create :congressional_district, full_code: '1', state: state }
    let! :congressional_district_geom { create :congressional_district_geom, full_code: '1' }

    let! :rep_one do
      create :congressional_rep, bioguide_id: 'rep_one', district: congressional_district
    end

    let! :rep_two do
      create :congressional_rep, bioguide_id: 'rep_two', state: state
    end

    let! :rep_three { create :congressional_rep }

    let! :governor { create :governor, state: state }

    it 'with coordinates retrieves the right set of reps' do
      get '/api/beta/reps?lat=41.0&long=-100.0'

      expect(response).to be_success
      expect(json['total_records']).to eq(3)
      expect(json['reps'].length).to eq(3)

      official_ids = json['reps'].map { |rep| rep['official_id'] }

      expect(official_ids).to include(rep_one.official_id)
      expect(official_ids).to include(rep_two.official_id)
      expect(official_ids).to include(governor.official_id)
      expect(official_ids).not_to include(rep_three.official_id)
    end

    it 'with an address retrieves the right set of reps' do
      get '/api/beta/reps?address=Cozad%20Nebraska'

      expect(response).to be_success
      expect(json['total_records']).to eq(3)
      expect(json['reps'].length).to eq(3)

      official_ids = json['reps'].map { |rep| rep['official_id'] }

      expect(official_ids).to include(rep_one.official_id)
      expect(official_ids).to include(rep_two.official_id)
      expect(official_ids).to include(governor.official_id)
      expect(official_ids).not_to include(rep_three.official_id)
    end

    it 'returns an empty array when lat and long params are given but are empty' do
      get '/api/beta/reps?lat=&long='

      expect(response).to be_success
      expect(json['total_records']).to eq(0)
      expect(json['reps'].length).to eq(0)
      expect(json['reps']).to eq([])
    end

    it 'returns an empty array when address param is given but is empty' do
      get '/api/beta/reps?address='

      expect(response).to be_success
      expect(json['total_records']).to eq(0)
      expect(json['reps'].length).to eq(0)
      expect(json['reps']).to eq([])
    end

    it 'returns an empty array when location params are not null but a district cannot be found' do
      get '/api/beta/reps?lat=0.0&long=0.0'

      expect(response).to be_success
      expect(json['total_records']).to eq(0)
      expect(json['reps'].length).to eq(0)
      expect(json['reps']).to eq([])
    end

    it 'leaves an impression' do
      get '/api/beta/reps?lat=41.0&long=-100.0'

      expect(Impression.count).to eq(1)
      expect(Impression.last.impressionable_type).to eq('District')
      expect(Impression.last.impressionable_id).to eq(congressional_district.id)
    end

    it 'only leaves unique impressions by IP' do
      expect(Impression.count).to eq(0)

      get '/api/beta/reps?lat=41.0&long=-100.0'

      expect(Impression.count).to eq(1)

      get '/api/beta/reps?lat=41.0&long=-100.0'

      expect(Impression.count).to eq(1)
    end
  end
end
