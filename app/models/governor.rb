# frozen_string_literal: true

class Governor < Rep
  NGA_PHOTO_SLUG = 'https://www.nga.org/files/live/sites/NGA/files/images/govportraits/'

  before_save :set_photo_url, if: -> { photo_url.blank? }
  before_save :set_role, :set_level

  def set_photo_url
    self.photo_url = "#{NGA_PHOTO_SLUG}#{state.abbr}-#{first + last}.jpg"
  end

  def set_role
    self.role = 'United States Governor'
  end

  def set_level
    self.level = 'state'
  end
end
