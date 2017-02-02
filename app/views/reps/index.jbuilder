# frozen_string_literal: true

json.array! @reps do |rep|
  if rep.id
    json.partial! 'rep', rep: rep
  else
    json.partial! 'state_rep', state_rep: rep
  end
end
