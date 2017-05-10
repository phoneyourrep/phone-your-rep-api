# frozen_string_literal: true

require 'rails_helper'

describe Coordinates do
  let!(:district_geom) { create :district_geom }
  let!(:district) { create :district, district_geoms: [district_geom] }

  context '#initialize' do
    it 'sets latlon when passed an address' do
      coord = Coordinates.new address: 'Cozad, NE'

      expect(coord.latlon).to be_a(Array)
      expect(coord.latlon.size).to be(2)
      expect(coord.all? { |i| i.is_a?(Float) }).to be(true)
    end

    it 'sets latlon when passed lat and long' do
      coord = Coordinates.new lat: '41.0', long: '-100.0'

      expect(coord.latlon).to be_a(Array)
      expect(coord.latlon.size).to be(2)
      expect(coord.all? { |i| i.is_a?(Float) }).to be(true)
    end

    it 'sets latlon to the latlon paramater' do
      coord = Coordinates.new latlon: ['41.0', '-100.0']

      expect(coord.latlon).to be_a(Array)
      expect(coord.latlon.size).to be(2)
      expect(coord.all? { |i| i.is_a?(Float) }).to be(true)
    end

    it 'sets latlon as an empty array when coordinates can\'t be found' do
      coord = Coordinates.new

      expect(coord.latlon).to be_a(Array)
      expect(coord.latlon.empty?).to be(true)
    end
  end

  context 'instance methods' do
    let(:coord) { Coordinates.new latlon: [41.0, -100.0] }

    it 'can iterate over it\'s latlon array' do
      expect(coord.map(&:to_s)).to eq(coord.latlon.map(&:to_s))
    end

    it '#last calls the last element of the latlon array' do
      expect(coord.last).to eq(coord.latlon.last)
    end

    it '#[] accesses the given index of the latlon array' do
      expect([coord[0], coord[1]]).to eq(coord.latlon)
    end

    it '#empty? returns true when the latlon array is empty' do
      expect(coord.empty?).to be(false)

      coord.instance_variable_set(:@latlon, [])

      expect(coord.empty?).to be(true)
    end

    it '#blank? returns true when the latlon array is blank' do
      expect(coord.blank?).to be(false)

      coord.instance_variable_set(:@latlon, '')

      expect(coord.blank?).to be(true)
    end
  end
end
