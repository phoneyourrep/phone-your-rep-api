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
    create_list(:rep, 10)
    get '/api/beta/reps?generate=true'

    expect(response).to be_success
    expect(json['total_records']).to eq(10)
    expect(json['reps'].length).to eq(10)
    json['reps'].each { |json_rep| expect(json_rep['bioguide_id']).to eq('bioguide_id') }
  end

  it 'retrieves a specific rep' do
    rep = create :rep
    get "/api/beta/reps/#{rep.bioguide_id}"

    expect(response).to be_success
    expect(json['bioguide_id']).to eq(rep.bioguide_id)
  end

  context 'searching by location' do
    let! :state { create :state }
    let! :district { create :district, full_code: '1', state: state }
    let! :district_geom { create :district_geom, full_code: '1' }
    let! :rep_one { create :rep, bioguide_id: 'rep_one', district: district }
    let! :rep_two { create :rep, bioguide_id: 'rep_two', state: state }
    let! :rep_three { create :rep }

    it 'with coordinates retrieves the right set of reps' do
      get '/api/beta/reps?lat=41.0&long=-100.0'

      expect(response).to be_success
      expect(json['total_records']).to eq(2)
      expect(json['reps'].length).to eq(2)

      bioguide_ids = json['reps'].map { |rep| rep['bioguide_id'] }

      expect(bioguide_ids).to include(rep_one.bioguide_id)
      expect(bioguide_ids).to include(rep_two.bioguide_id)
      expect(bioguide_ids).not_to include(rep_three.bioguide_id)
    end

    it 'with an address retrieves the right set of reps' do
      get '/api/beta/reps?address=Cozad%20Nebraska'

      expect(response).to be_success
      expect(json['total_records']).to eq(2)
      expect(json['reps'].length).to eq(2)

      bioguide_ids = json['reps'].map { |rep| rep['bioguide_id'] }

      expect(bioguide_ids).to include(rep_one.bioguide_id)
      expect(bioguide_ids).to include(rep_two.bioguide_id)
      expect(bioguide_ids).not_to include(rep_three.bioguide_id)
    end

    it 'leaves an impression' do
      get '/api/beta/reps?lat=41.0&long=-100.0'

      expect(Impression.count).to eq(1)
      expect(Impression.last.impressionable_type).to eq('District')
      expect(Impression.last.impressionable_id).to eq(district.id)
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
