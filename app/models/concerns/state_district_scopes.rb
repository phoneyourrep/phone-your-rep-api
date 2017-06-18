# frozen_string_literal: true

module StateDistrictScopes
  def self.included(base)
    base.class_eval do
      scope :upper, -> { where chamber: 'upper' }
      scope :lower, -> { where chamber: 'lower' }
    end
  end
end
