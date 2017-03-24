# frozen_string_literal: true
require 'csv'
class ZctaDistrict < ApplicationRecord
  belongs_to :zcta
  belongs_to :district

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << %w(zip state district)
      all.each do |zcta|
        csv << [zcta.zip_code, zcta.state, zcta.district_code]
      end
    end
  end
end
