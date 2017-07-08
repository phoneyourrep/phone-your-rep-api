# frozen_string_literal: true

module LowerChamberByDefault
  extend ActiveSupport::Concern

  included do
    before_save :set_chamber, if: -> { chamber.nil? }
  end

  def set_chamber
    self.chamber = 'lower'
  end
end
