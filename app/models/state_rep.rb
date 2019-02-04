# frozen_string_literal: true

class StateRep < Rep
  before_save :set_state_leg_id, :set_role, :set_florida_photo_url
  before_save :set_party_as_democrat, if: -> { party == 'Democratic' }

  def set_state_leg_id
    self.state_leg_id = official_id if state_leg_id.blank?
  end

  def set_role
    self.role = "State #{state.send("#{chamber}_chamber_title")}"
  end

  def set_party_as_democrat
    self.party = 'Democrat'
  end

  def set_florida_photo_url
    self.photo_url = self.photo_url.sub("flhouse", "myfloridahouse")
    self.photo = photo_url
  end
end
