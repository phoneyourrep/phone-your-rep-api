# frozen_string_literal: true

module LowerChamberByDefault
  def self.included(base)
    base.class_eval do
      before_save :set_chamber, if: -> { chamber.nil? }
    end
  end

  def set_chamber
    self.chamber = 'lower'
  end
end
