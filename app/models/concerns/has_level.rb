# frozen_string_literal: true

module HasLevel
  def self.included(base)
    base.class_eval do
      scope :level, ->(level) { where level: level }
    end
  end

  def set_level
    self.level = if is_a?(OfficeLocation)
                   rep&.level
                 elsif type && type.match?(/Congressional/)
                   'national'
                 elsif type && type.match?(/State/)
                   'state'
                 end
  end
end

districts.reduce([]) do |memo, district|
   unless StateDistrict.find_by(state: State.find_by(abbr: district.abbr.upcase), chamber: district.chamber, name: district.name)
     memo << district
   else
     memo
   end
end