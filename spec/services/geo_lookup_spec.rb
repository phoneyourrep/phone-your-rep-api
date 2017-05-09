# frozen_string_literal: true

require 'rails_helper'

describe GeoLookup do
  let(:geo_lookup) { GeoLookup.new(lat: '41.0', long: '-100.0') }
  let(:geo_lookup_with_no_district) { GeoLookup.new }
  let!(:office_location_one) { create :office_location, latitude: 41.5, longitude: -100.5 }
  let!(:office_location_two) { create :office_location, latitude: 42.0, longitude: -101.0 }
  let!(:office_location_three) { create :office_location, latitude: 0.0, longitude: -0.0 }

  let!(:inactive_office_location) do
    create :office_location, latitude: 41.0, longitude: -100.0, active: false
  end

  let!(:rep_one) { create :rep, office_locations: [office_location_one, office_location_two] }
  let!(:rep_two) { create :rep }
  let!(:rep_three) { create :rep }
  let!(:inactive_rep) { create :rep, active: false }
  let!(:district_geom) { create :district_geom, full_code: '1' }

  let!(:district) do
    create :district, full_code: '1', state_code: '1', reps: [rep_one, inactive_rep]
  end

  let!(:state) do
    create :state, state_code: '1', reps: [rep_two, inactive_rep]
  end

  after(:all) { [Rep, OfficeLocation, District, State, DistrictGeom].each(&:destroy_all) }

  context '#initialize' do
    it 'finds the correct District and State when passed coordinates' do
      expect(geo_lookup.district).to eq(district)
      expect(geo_lookup.state).to eq(state)
    end

    it 'finds the correct District and state when passed an address' do
      geo_lookup_by_address = GeoLookup.new(address: 'Cozad, NE 69130, USA')

      expect(geo_lookup_by_address.district).to eq(district)
      expect(geo_lookup_by_address.state).to eq(state)
    end
  end

  context '#find_reps' do
    let(:reps) { geo_lookup.find_reps }

    it 'returns only the right collection of active reps' do
      expect(reps).to include(rep_one)
      expect(reps).to include(rep_two)
      expect(reps).not_to include(rep_three)
      expect(reps).not_to include(inactive_rep)
    end

    it 'returns an empty ActiveRecord::Relation if a district can\'t be found' do
      reps = geo_lookup_with_no_district.find_reps

      expect(reps).to be_a(ActiveRecord::Relation)
      expect(reps).to be_empty
    end
  end

  context '#find_office_locations' do
    let(:geo_lookup_with_radius) { GeoLookup.new(lat: '41.0', long: '-100.0', radius: '100') }
    let(:office_locations) { geo_lookup_with_radius.find_office_locations }

    it 'returns only the right collection of active office_locations within the radius' do
      expect(office_locations).to include(office_location_one)
      expect(office_locations).to include(office_location_two)
      expect(office_locations).not_to include(office_location_three)
      expect(office_locations).not_to include(inactive_office_location)
    end

    it 'returns an empty ActiveRecord::Relation if coordinates can\'t be found' do
      office_locations = geo_lookup_with_no_district.find_office_locations

      expect(office_locations).to be_a(ActiveRecord::Relation)
      expect(office_locations).to be_empty
    end
  end
end
