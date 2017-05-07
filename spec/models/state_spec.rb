# frozen_string_literal: true

require 'rails_helper'

describe State, type: :model do
  before(:all) { [State, District, Rep].each(&:destroy_all) }

  let!(:district_one) { create :district, state_code: '1' }
  let!(:district_two) { create :district, state_code: '2' }
  let!(:rep_one) { create :rep }
  let!(:rep_two) { create :rep }
  let!(:state_geom_one) { create :state_geom, state_code: '1' }
  let!(:state_geom_two) { create :state_geom, state_code: '2' }
  let!(:state) { create :state, state_code: '1', reps: [rep_one, rep_two] }

  it 'has many districts' do
    expect(state.districts).to be_a(ActiveRecord::Relation)
    expect(state.districts.count).to eq(1)
    expect(state.districts).to include(district_one)
    expect(state.districts).to_not include(district_two)
  end

  it 'has many reps' do
    expect(state.reps).to be_a(ActiveRecord::Relation)
    expect(state.reps.count).to eq(2)
    expect(state.reps).to include(rep_one)
    expect(state.reps).to include(rep_two)
  end

  it 'has many state_geoms' do
    expect(state.state_geoms).to be_a(ActiveRecord::Relation)
    expect(state.state_geoms.count).to eq(1)
    expect(state.state_geoms).to include(state_geom_one)
    expect(state.state_geoms).to_not include(state_geom_two)
  end
end
