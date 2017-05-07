# frozen_string_literal: true

require 'rails_helper'

describe State, type: :model do
  before(:all) { [State, District, Rep].each(&:destroy_all) }

  let(:district_one) { create :district }
  let(:district_two) { create :district }
  let(:rep_one) { create :rep }
  let(:rep_two) { create :rep }
  let(:state) { create :state, districts: [district_one, district_two], reps: [rep_one, rep_two] }

  it 'has many districts' do
    expect(state.districts).to be_a(ActiveRecord::Relation)
    expect(state.districts.count).to eq(2)
    expect(state.districts.first).to eq(district_one)
    expect(state.districts.last).to eq(district_two)
  end

  it 'has many reps' do
    expect(state.reps).to be_a(ActiveRecord::Relation)
    expect(state.reps.count).to eq(2)
    expect(state.reps.first).to eq(rep_one)
    expect(state.reps.last).to eq(rep_two)
  end
end
