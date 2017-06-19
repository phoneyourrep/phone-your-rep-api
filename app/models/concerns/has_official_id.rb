# frozen_string_literal: true

module HasOfficialID
  def set_official_id
    self.official_id = bioguide_id || state_leg_id if official_id.blank?
  end
end
