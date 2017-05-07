# frozen_string_literal: true

require 'rails_helper'

describe DistrictGeom, type: :model do
  let!(:nebraska_at_large) { create :district_geom }
  let(:cozad_ne) { [41.0, -100.0] }

  context '.containing_latlon' do
    it 'finds the DistrictGeoms that encompass the coordinates' do
      result = DistrictGeom.containing_latlon(*cozad_ne)
      expect(result).to be_a(ActiveRecord::Relation)
      expect(result).to include(nebraska_at_large)
    end

    it 'ignores the DistrictGeoms that don\'t' do
      result = DistrictGeom.containing_latlon(0.0, 0.0)
      expect(result).to be_a(ActiveRecord::Relation)
      expect(result).not_to include(nebraska_at_large)
    end
  end
end
