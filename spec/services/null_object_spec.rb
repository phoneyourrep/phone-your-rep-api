# frozen_string_literal: true

require 'rails_helper'

describe NullObject do
  let(:null) { NullObject.new }

  context 'presence checking methods' do
    it '#nil? returns true' do
      expect(null.nil?).to be(true)
    end

    it '#blank? returns true' do
      expect(null.blank?).to be(true)
    end

    it '#empty? returns true' do
      expect(null.empty?).to be(true)
    end
  end

  context 'all other predicate methods' do
    it 'returns false' do
      expect(null.zero?).to be(false)
      expect(null.hot?).to be(false)
      expect(null.is_a?(String)).to be(false)
      expect(null.hungry?).to be(false)
    end
  end

  context 'explicit conversions' do
    it 'acts like nil' do
      expect(null.to_s).to eq('')
      expect(null.to_i).to eq(0)
      expect(null.to_f).to eq(0.0)
      expect(null.to_a).to eq([])
      expect(null.to_h).to eq({})
      expect(null.to_c).to eq((0 + 0i))
      expect(null.to_r).to eq((0 / 1))
    end
  end

  context 'method missing' do
    it 'is a black hole for all other methods' do
      expect(null.chain.anything.and.you.get.null).to be(null)
    end
  end
end
