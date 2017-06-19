# frozen_string_literal: true

class CongressionalRep < Rep
  before_save :set_photo_url, :set_bioguide_id, :set_role

  def set_photo_url
    self.photo_url = "https://phoneyourrep.github.io/images/congress/450x550/#{bioguide_id}.jpg"
  end

  def set_bioguide_id
    self.bioguide_id = official_id if bioguide_id.blank?
  end

  def set_role
    self.role = case chamber
                when 'lower' then 'United States Representative'
                when 'upper' then 'United States Senator'
                end
  end
end
