# frozen_string_literal: true

require 'rails_helper'

describe District, type: :model do
  before(:all) { [State, District, Rep, DistrictGeom].each(&:destroy_all) }

  after(:all) { [State, District, Rep, DistrictGeom].each(&:destroy_all) }

  let!(:rep_one) { create :rep }
  let!(:rep_two) { create :rep }
  let!(:state) { create :state, state_code: '1' }
  let!(:district_geom_one) { create :district_geom, full_code: '1' }
  let!(:district_geom_two) { create :district_geom, full_code: '2' }
  let!(:district) { create :district, full_code: '1', state_code: '1', reps: [rep_one, rep_two] }

  it 'belongs_to a state' do
    expect(district.state).to eq(state)
  end

  it 'has many reps' do
    expect(district.reps).to be_a(ActiveRecord::Relation)
    expect(district.reps.count).to eq(2)
    expect(district.reps.first).to eq(rep_one)
    expect(district.reps.last).to eq(rep_two)
  end

  it 'has many district_geoms' do
    expect(district.district_geoms).to be_a(ActiveRecord::Relation)
    expect(district.district_geoms.count).to eq(1)
    expect(district.district_geoms).to include(district_geom_one)
    expect(district.district_geoms).to_not include(district_geom_two)
  end
end
