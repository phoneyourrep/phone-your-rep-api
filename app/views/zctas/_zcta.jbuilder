# frozen_string_literal: true
json.self zcta_url(zcta.zcta)
json.extract! zcta,
              :zcta

if @districts
  json.set! 'districts', @districts do |district|
    json.partial! 'districts/district', district: district
  end
end

if @reps
  json.set! 'reps', @reps do |rep|
    json.partial! 'reps/rep', rep: rep
  end
end
