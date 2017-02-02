# frozen_string_literal: true
json.source 'https://www.openstates.org/'
json.extract! state_office_location,
              :office_type,
              :address,
              :city,
              :state,
              :zip,
              :phone