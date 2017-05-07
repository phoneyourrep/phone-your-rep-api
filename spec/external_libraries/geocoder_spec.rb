# frozen_string_literal: true

require 'rails_helper'

describe Geocoder do
  let(:production_options) { GeocoderConfig::PRODUCTION_OPTIONS }
  let(:config) { Geocoder.config }

  context 'in the development environment' do
    it 'does not add custom configuration to the module' do
      expect(config.timeout).to eq(3)
      expect(config.lookup).to eq(:google)
      expect(config.language).to eq(:en)
      expect(config.use_https).to be(false)
      expect(config.api_key).to be(nil)
    end
  end

  context 'in the production environment' do
    before(:all) do
      Rails.env = 'production'
      load Rails.root.join('config', 'initializers', 'geocoder.rb').to_s
    end

    after(:all) { Rails.env = 'test' }

    it 'initializer properly configures the module with custom options' do
      expect(config.timeout).to eq(production_options[:timeout])
      expect(config.lookup).to eq(production_options[:lookup])
      expect(config.language).to eq(production_options[:language])
      expect(config.use_https).to be(production_options[:use_https])
      expect(config.api_key).to eq(production_options[:api_key])
    end

    it 'converts an address to coordinates' do
      expect(Geocoder.coordinates('Vermont')).to be_a(Array)
    end

    it 'converts coordinates to an address' do
      expect(Geocoder.address([43.0, -74.0])).to be_a(String)
    end
  end
end
