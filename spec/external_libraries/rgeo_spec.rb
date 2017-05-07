# frozen_string_literal: true

require 'rails_helper'

describe RGeo do
  context 'PostGIS configuration' do
    it 'supports the GEOS library' do
      expect(RGeo::Geos.supported?).to be(true)
    end
  end
end
