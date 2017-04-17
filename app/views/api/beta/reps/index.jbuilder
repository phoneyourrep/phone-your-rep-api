# frozen_string_literal: true

json.total_records @reps.count
json.set! '_links' do
  json.self do
    json.href @self
  end
end
json.set! 'reps', @reps do |rep|
  json.partial! 'rep', rep: rep
end
