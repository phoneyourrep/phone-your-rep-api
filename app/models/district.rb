# frozen_string_literal: true

class District < ApplicationRecord
  include HasChamber
  include HasLevel

  belongs_to :state, foreign_key: :state_code, primary_key: :state_code
  has_many :reps
  has_many :zcta_districts, dependent: :destroy
  has_many :zctas, through: :zcta_districts

  validates :state, presence: true

  before_save :set_level

  is_impressionable counter_cache: true, column_name: :requests

  scope :congressional, -> { where type: 'CongressionalDistrict' }
  scope :state, -> { where type: 'StateDistrict' }
end
