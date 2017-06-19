# frozen_string_literal: true

class DistrictGeom < ApplicationRecord
  include Geographic
  include HasChamber
  include HasLevel

  belongs_to :district, foreign_key: :full_code, primary_key: :full_code

  before_save :set_level

  scope :congressional, -> { where type: 'CongressionalDistrictGeom' }
  scope :state, -> { where type: 'StateDistrictGeom' }
end
