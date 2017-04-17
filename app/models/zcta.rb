# frozen_string_literal: true

class Zcta < ApplicationRecord
  has_many :zcta_districts, dependent: :destroy
  has_many :districts, through: :zcta_districts
end
