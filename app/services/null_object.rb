# frozen_string_literal: true

NullObject = Naught.build do |config|
  config.black_hole
  config.define_explicit_conversions
  config.predicates_return false

  def nil?
    true
  end

  def blank?
    true
  end

  def empty?
    true
  end
end
