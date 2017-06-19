# frozen_string_literal: true

class StateRep < Rep
  before_save :set_state_leg_id

  def set_state_leg_id
    self.state_leg_id = official_id if state_leg_id.blank?
  end
end
