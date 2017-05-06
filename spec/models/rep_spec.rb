# frozen_string_literal: true

require 'rails_helper'

describe Rep, type: :model do
  before :all do
    @state    = create :state
    @district = create :district, state: @state
    @office   = create :office_location
    @avatar   = create :avatar

    @rep = create(
      :rep,
      state: @state,
      district: @district,
      office_locations: [@office],
      avatar: @avatar
    )
  end

  it 'has a bioguide_id' do
    expect(@rep.bioguide_id).to eq('S000033')
  end

  it 'has an official full name' do
    expect(@rep.official_full).to eq('Bernard Sanders')
  end

  it 'belongs_to a state' do
    expect(@rep.state).to be(@state)
  end

  it 'belongs_to a district' do
    expect(@rep.district).to be(@district)
  end

  it 'has office_locations' do
    expect(@rep.office_locations).to be_a(ActiveRecord::Relation)
    expect(@rep.office_locations.count).to eq(1)
    expect(@rep.office_locations.first).to be(@office)
  end

  it 'has an avatar' do
    expect(@rep.avatar).to be(@avatar)
  end

  it 'has a photo_slug' do
    photo_slug = 'https://phoneyourrep.github.io/images/congress/450x550/S000033.jpg'

    expect(@rep.photo_slug).to eq(photo_slug)
  end
end
