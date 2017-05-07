# frozen_string_literal: true

require 'rails_helper'

describe Avatar, type: :model do
  let(:avatar) { build :avatar }
  let(:photo_url) { 'http://www.cutestpaw.com/wp-content/uploads/2011/11/Henke.jpg' }

  it 'belongs_to a rep' do
    rep = create :rep
    avatar.rep = rep
    avatar.save

    expect(avatar.rep).to eq(rep)
  end

  context '#fetch_data' do
    it 'can fetch and store data for an arbitrary photo_url' do
      expect(avatar.data).to be(nil)
      avatar.fetch_data photo_url
      expect(avatar.data).to be_a(String)
    end

    it 'rescues HTTP errors and does not update the data attribute when given a bad URI' do
      photo_not_found = 'https://phoneyourrep.github.io/images/congress/450x550/not-found.jpg'
      expect(avatar.data).to be(nil)
      expect { avatar.fetch_data(photo_not_found) }.not_to raise_error
      expect(avatar.data).to be(nil)
    end
  end
end
