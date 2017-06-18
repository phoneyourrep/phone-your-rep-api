# frozen_string_literal: true

class CongressionalRep < Rep
  before_save :set_photo_url

  def set_photo_url
    self.photo_url = "https://phoneyourrep.github.io/images/congress/450x550/#{bioguide_id}.jpg"
  end
end
