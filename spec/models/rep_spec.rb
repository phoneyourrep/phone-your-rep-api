# frozen_string_literal: true

require 'rails_helper'

describe Rep, type: :model do
  before :all do
    @state        = create :state
    @district     = create :district, state: @state
    @office_one   = create :office_location, active: false
    @office_two   = create :office_location, latitude: 4.0, longitude: 4.0
    @office_three = create :office_location, latitude: 2.0, longitude: 2.0
    @office_four  = create :office_location, latitude: 3.0, longitude: 3.0
    @avatar       = create :avatar

    @rep = create(
      :rep,
      bioguide_id: 'S000033',
      official_full: 'Bernard Sanders',
      state: @state,
      district: @district,
      office_locations: [@office_one, @office_two, @office_three, @office_four],
      avatar: @avatar
    )
  end

  after(:all) { [Rep, State, District, OfficeLocation, Avatar].each(&:destroy_all) }

  it 'has a bioguide_id' do
    expect(@rep.bioguide_id).to eq('S000033')
  end

  it 'has an official full name' do
    expect(@rep.official_full).to eq('Bernard Sanders')
  end

  it 'belongs_to a state' do
    expect(@rep.state).to eq(@state)
  end

  it 'belongs_to a district' do
    expect(@rep.district).to eq(@district)
  end

  it 'has many office_locations' do
    expect(@rep.office_locations).to be_a(ActiveRecord::Relation)
    expect(@rep.office_locations.count).to eq(4)
    expect(@rep.office_locations).to include(@office_one)
    expect(@rep.office_locations).to include(@office_two)
    expect(@rep.office_locations).to include(@office_three)
    expect(@rep.office_locations).to include(@office_four)
  end

  it 'has many active_office_locations' do
    expect(@rep.active_office_locations).to be_a(ActiveRecord::Relation)
    expect(@rep.active_office_locations.count).to eq(3)
    expect(@rep.active_office_locations).not_to include(@office_one)
    expect(@rep.active_office_locations).to include(@office_two)
    expect(@rep.active_office_locations).to include(@office_three)
    expect(@rep.active_office_locations).to include(@office_four)
  end

  it 'has an avatar' do
    expect(@rep.avatar).to be(@avatar)
  end

  it 'has a photo_slug based on its bioguide_id' do
    photo_slug = 'https://phoneyourrep.github.io/images/congress/450x550/S000033.jpg'

    expect(@rep.photo_slug).to eq(photo_slug)
  end

  it '#fetch_avatar_data updates its avatar with data for its own photo_slug' do
    expect(@avatar.data).to be(nil)

    @rep.fetch_avatar_data
    data = open(@rep.photo_slug, &:read)

    expect(@avatar.data).not_to be(nil)
    expect(@avatar.data).to eq(data)
  end

  it '#fetch_avatar_data creates an avatar if one does not already exist' do
    rep = create :rep
    expect(rep.avatar).to be(nil)
    rep.add_photo
    expect(rep.avatar).to be_a(Avatar)
  end

  it '#add_photo updates the photo attribute if the #photo_slug returns valid data' do
    expect(@rep.photo).to be(nil)

    @rep.add_photo

    expect(@rep.photo).to eq(@rep.photo_slug)
  end

  it '#add_photo ensures the photo attribute is nil if #photo_slug does not return valid data' do
    rep = create :rep, bioguide_id: 'not-found'
    rep.add_photo

    expect(rep.photo).to be(nil)
  end

  it '#district_code returns the district#code when a district is present' do
    expect(@rep.district_code).to eq(@district.code)
  end

  it '#district_code returns nil when a district is not present' do
    @rep.district = nil

    expect(@rep.district_code).to be(nil)
  end

  context '#sorted_offices_array' do
    context 'when #sort_offices is not called' do
      it 'will return its active_office_locations unsorted' do
        expect(@rep.sorted_offices).to be(nil)
        expect(@rep.sorted_offices_array).not_to eq(@rep.sorted_offices)
        expect(@rep.sorted_offices_array).not_to include(@office_one)
        expect(@rep.sorted_offices_array).to include(@office_two)
        expect(@rep.sorted_offices_array).to include(@office_three)
        expect(@rep.sorted_offices_array).to include(@office_four)
      end
    end

    context 'when #sort_offices is called' do
      it 'will return its active_office_locations sorted by distance' do
        @rep.sort_offices [0.0, 0.0]

        expect(@rep.sorted_offices_array).to eq(@rep.sorted_offices)
        expect(@rep.sorted_offices).not_to include(@office_one)
        expect(@rep.sorted_offices.first).to eq(@office_three)
        expect(@rep.sorted_offices.second).to eq(@office_four)
        expect(@rep.sorted_offices.third).to eq(@office_two)
      end

      it 'will calculate distance for each active_office_location' do
        @rep.sort_offices [0.0, 0.0]
        sorted_offices = @rep.sorted_offices

        expect(sorted_offices.third.distance).to be > sorted_offices.second.distance
        expect(sorted_offices.second.distance).to be > sorted_offices.first.distance
        expect(sorted_offices.first.distance).to be > 0.0
      end
    end
  end
end
