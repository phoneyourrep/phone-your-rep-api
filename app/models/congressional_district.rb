# frozen_string_literal: true

class CongressionalDistrict < District
  before_save :set_chamber, if: -> { chamber.nil? }
  is_impressionable counter_cache: true, column_name: :requests

  def set_chamber
    self.chamber = 'lower'
  end
end
