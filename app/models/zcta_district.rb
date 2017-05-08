# frozen_string_literal: true

require 'csv'
class ZctaDistrict < ApplicationRecord
  belongs_to :zcta
  belongs_to :district

  after_validation :set_attributes

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << %w[zip state district]
      all.each do |zcta|
        csv << [zcta.zip_code, zcta.state, zcta.district_code]
      end
    end
  end

  def set_attributes
    self.zip_code      = zcta.zcta
    self.state         = district.state.abbr
    self.district_code = district.code
  end
end
