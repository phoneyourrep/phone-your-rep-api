# frozen_string_literal: true

module HasChamber
  extend ActiveSupport::Concern

  included do
    scope :upper, -> { where chamber: 'upper' }
    scope :lower, -> { where chamber: 'lower' }
    scope :chamber, ->(chamber) { where chamber: chamber }
  end
end
