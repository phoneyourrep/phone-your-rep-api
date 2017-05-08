# frozen_string_literal: true

require 'rails_helper'

describe ZctaDistrict, type: :model do
  before :all { [Zcta, District, ZctaDistrict, State].each(&:destroy_all) }
  after :all { [Zcta, District, ZctaDistrict, State].each(&:destroy_all) }

  let(:zcta_one) { create :zcta, zcta: '11111' }
  let(:zcta_two) { create :zcta, zcta: '22222' }
  let(:state_one) { create :state, abbr: 'one' }
  let(:state_two) { create :state, abbr: 'two' }
  let(:district_one) { create :district, code: '1', state: state_one }
  let(:district_two) { create :district, code: '2', state: state_two }

  let!(:zcta_district_one) { create :zcta_district, zcta: zcta_one, district: district_one }
  let!(:zcta_district_two) { create :zcta_district, zcta: zcta_two, district: district_two }

  context '.to_csv' do
    it 'returns a formatted CSV containing zip to district relationships' do
      csv = "zip,state,district\n11111,one,1\n22222,two,2\n"
      expect(ZctaDistrict.to_csv).to eq(csv)
    end
  end
end
