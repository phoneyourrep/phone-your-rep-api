# frozen_string_literal: true

require 'rails_helper'

describe VCardBuilder do
  let :office do
    create :office_location, address: '220 Henry St', city: 'New York', state: 'NY', zip: '10002'
  end

  let :rep do
    create :rep, official_full: 'Full Name', role: 'Rep'
  end

  it 'makes a v_card when passed an office_location and rep as parameters' do
    v_card_builder = VCardBuilder.new office, rep
    v_card = v_card_builder.make_v_card photo: false

    expect(v_card).to be_a(Vpim::Vcard)
    expect(v_card.to_s).to include('BEGIN:VCARD')
  end
end
