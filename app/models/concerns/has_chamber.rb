# frozen_string_literal: true

module HasChamber
  def self.included(base)
    base.class_eval do
      scope :upper, -> { where chamber: 'upper' }
      scope :lower, -> { where chamber: 'lower' }
      scope :chamber, ->(chamber) { where chamber: chamber }
    end
  end
end
