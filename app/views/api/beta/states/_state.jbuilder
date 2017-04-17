# frozen_string_literal: true

json.self api_beta_state_url(state.state_code)
json.extract! state,
              :state_code,
              :name,
              :abbr
