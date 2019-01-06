# frozen_string_literal: true

class Governor < Rep
  GOVERNOR_PHOTO_SLUG = 'https://cdn.civil.services/us-governors/headshots/512x512/'

  before_save :set_photo_url, if: -> { photo_url.blank? }
  before_save :set_role, :set_level, :set_official_id, :make_sure_district_and_chamber_are_empty

  validates :state, :official_full, presence: true

  def set_official_id
    self.official_id = "#{state.abbr}-#{official_full.downcase.split(' ').join('-')}".
                       delete('".')
  end

  def set_photo_url
    self.photo_url = "#{GOVERNOR_PHOTO_SLUG}#{first.downcase}-#{last.downcase}.jpg"
  end

  def set_role
    self.role = 'Governor'
  end

  def set_level
    self.level = 'state'
  end

  def make_sure_district_and_chamber_are_empty
    self.district_id = nil
    self.chamber     = nil
  end
end
