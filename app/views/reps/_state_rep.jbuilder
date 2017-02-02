json.source 'https://www.openstates.org/'

json.extract! state_rep,
              :official_full,
              :role,
              :party,
              :url,
              :photo