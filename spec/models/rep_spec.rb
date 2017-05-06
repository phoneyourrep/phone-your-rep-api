# frozen_string_literal: true

require 'rails_helper'

describe Rep, type: :model do
  before :all do
    [Rep, State, District, OfficeLocation, Avatar].each(&:destroy_all)

    @state      = create :state
    @district   = create :district, state: @state
    @office_one = create :office_location, active: false
    @office_two = create :office_location, active: true
    @avatar     = create :avatar

    @rep = create(
      :rep,
      bioguide_id: 'S000033',
      official_full: 'Bernard Sanders',
      state: @state,
      district: @district,
      office_locations: [@office_one, @office_two],
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

  it 'has many office_locations' do
    expect(@rep.office_locations).to be_a(ActiveRecord::Relation)
    expect(@rep.office_locations.count).to eq(2)
    expect(@rep.office_locations.first).to be(@office_one)
    expect(@rep.office_locations.last).to be(@office_two)
  end

  it 'has many active_office_locations' do
    expect(@rep.active_office_locations).to be_a(ActiveRecord::Relation)
    expect(@rep.active_office_locations.count).to eq(1)
    expect(@rep.active_office_locations).not_to include(@office_one)
    expect(@rep.active_office_locations).to include(@office_two)
  end

  it 'has an avatar' do
    expect(@rep.avatar).to be(@avatar)
  end

  it 'has a photo_slug' do
    photo_slug = 'https://phoneyourrep.github.io/images/congress/450x550/S000033.jpg'

    expect(@rep.photo_slug).to eq(photo_slug)
  end
end
