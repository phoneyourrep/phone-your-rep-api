# frozen_string_literal: true

require 'rails_helper'

describe VCard, type: :model do
  let(:office) { create :office_location }
  let(:v_card) { create :v_card, office_location: office }

  after(:all) { [OfficeLocation, VCard].each(&:destroy_all) }

  it 'belongs_to an office_location' do
    expect(v_card.office_location).to be(office)
    expect(office.v_card).to be(v_card)
  end
end
