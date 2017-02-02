module OpenStatesable
  module_function

  def get_state_reps(coordinates)
    @state_reps = GetYourRep::OpenStates.all_reps coordinates
  end
end
