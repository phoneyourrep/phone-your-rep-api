# frozen_string_literal: true

require 'rails_helper'

describe StateGeom, type: :model do
  let!(:nebraska) { create :state_geom }
  let(:cozad_ne) { [41.0, -100.0] }

  it '#containing_latlon finds the StateGeoms that encompass the coordinates' do
    result = StateGeom.containing_latlon(*cozad_ne)
    expect(result).to be_a(ActiveRecord::Relation)
    expect(result).to include(nebraska)
  end

  it '#containing_latlon ignores the DistrictGeoms that don\'t' do
    result = StateGeom.containing_latlon(0.0, 0.0)
    expect(result).to be_a(ActiveRecord::Relation)
    expect(result).not_to include(nebraska)
  end
end
