# frozen_string_literal: true

require 'rails_helper'

describe State, type: :model do
  before :all do
    [State, District, Rep].each(&:destroy_all)

    @state        = create :state
    @district_one = create :district, state: @state
    @district_two = create :district, state: @state
    @rep_one      = create :rep, state: @state
    @rep_two      = create :rep, state: @state
  end

  it 'has many districts' do
    expect(@state.districts).to be_a(ActiveRecord::Relation)
    expect(@state.districts.count).to eq(2)
    expect(@state.districts.first).to eq(@district_one)
    expect(@state.districts.last).to eq(@district_two)
  end

  it 'has many reps' do
    expect(@state.reps).to be_a(ActiveRecord::Relation)
    expect(@state.reps.count).to eq(2)
    expect(@state.reps.first).to eq(@rep_one)
    expect(@state.reps.last).to eq(@rep_two)
  end
end
