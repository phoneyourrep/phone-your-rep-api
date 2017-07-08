# frozen_string_literal: true

module HasLevel
  extend ActiveSupport::Concern

  included do
    scope :level, ->(level) { where level: level }
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
