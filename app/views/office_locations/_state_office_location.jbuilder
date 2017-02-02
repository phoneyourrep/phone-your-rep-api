# frozen_string_literal: true
json.source 'https://www.openstates.org/'
json.extract! state_office_location,
              :office_type,
              :address,
              :city,
              :state,
              :zip,
              :phone
encoded_v_card =state_office_location.v_card.gsub(' ', '%20').
  gsub(':', '%3A').
  gsub("\n", '%0A').
  gsub(';', '%3B').
  gsub(',', '%2C')
json.v_card_link "#{@pfx}/v_cards?v_card=#{encoded_v_card}&rep=#{state_office_location.
  rep.
  official_full.
  gsub(' ', '%20')}"