# frozen_string_literal: true

require 'rails_helper'

describe Rep, type: :model do
  before :all do
    @state = State.create
    @district = District.create state: @state

    @rep = Rep.create(
      bioguide_id: 'S000033',
      official_full: 'Bernard Sanders',
      state: @state,
      district: @district
    )
  end

  it 'has a bioguide_id' do
    expect(@rep.bioguide_id).to eq('S000033')
  end

  it 'has an official full name' do
    expect(@rep.official_full).to eq('Bernard Sanders')
  end

  it 'has a state' do
    expect(@rep.state).to eq(@state)
  end

  it 'has a district' do
    expect(@rep.district).to eq(@district)
  end

  it 'has a photo_slug' do
    photo_slug = 'https://phoneyourrep.github.io/images/congress/450x550/S000033.jpg'

    expect(@rep.photo_slug).to eq(photo_slug)
  end
end
