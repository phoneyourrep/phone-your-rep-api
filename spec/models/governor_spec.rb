# frozen_string_literal: true

require 'rails_helper'

describe Governor, type: :model do
  before :all do
    @state        = create :state, abbr: 'VT'
    @office_one   = create :office_location, active: false
    @office_two   = create :office_location, latitude: 4.0, longitude: 4.0
    @office_three = create :office_location, latitude: 2.0, longitude: 2.0
    @office_four  = create :office_location, latitude: 3.0, longitude: 3.0

    @rep = create(
      :governor,
      official_full: 'Philip Scott',
      first: 'Philip',
      last: 'Scott',
      state: @state,
      office_locations: [@office_one, @office_two, @office_three, @office_four]
    )
  end

  after(:all) { [Rep, State, OfficeLocation].each(&:destroy_all) }

  it 'has an official full name' do
    expect(@rep.official_full).to eq('Philip Scott')
  end

  it 'constructs an official_id based on the name and state' do
    expect(@rep.official_id).to eq('VT-philip-scott')
  end

  it 'belongs_to a state' do
    expect(@rep.state).to eq(@state)
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

  it 'constructs a photo_url based on its official_id' do
    photo_url = 'https://cdn.civil.services/us-governors/headshots/512x512/philip-scott.jpg'

    expect(@rep.photo_url).to eq(photo_url)
  end

  it '#add_photo updates the photo attribute if the #photo_url returns valid data' do
    expect(@rep.photo).to be(nil)

    @rep.add_photo

    expect(@rep.photo).to eq(@rep.photo_url)
  end

  it '#add_photo ensures the photo attribute is nil if #photo_url does not return valid data' do
    rep = create :governor, bioguide_id: 'not-found'
    rep.add_photo

    expect(rep.photo).to be(nil)
  end

  context '#sorted_offices' do
    context 'when #sort_offices is not called' do
      it 'will return its active_office_locations unsorted' do
        expect(@rep.sorted_offices).not_to include(@office_one)
        expect(@rep.sorted_offices).to include(@office_two)
        expect(@rep.sorted_offices).to include(@office_three)
        expect(@rep.sorted_offices).to include(@office_four)
        expect(@rep.sorted_offices.all? { |off| off.distance.nil? }).to be true
      end
    end

    context 'when #sort_offices is called' do
      it 'will return its active_office_locations sorted by distance' do
        @rep.sort_offices [0.0, 0.0]

        expect(@rep.sorted_offices).not_to include(@office_one)
        expect(@rep.sorted_offices.first).to eq(@office_three)
        expect(@rep.sorted_offices.second).to eq(@office_four)
        expect(@rep.sorted_offices.third).to eq(@office_two)
        expect(@rep.sorted_offices.none? { |off| off.distance.nil? }).to be true
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
