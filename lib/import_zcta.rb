# frozen_string_literal: true
require 'csv'
require_relative '../config/environment.rb'

class ImportZCTA
  attr_reader :files

  def initialize(*files)
    @files = files
  end

  def import
    files.each { |file| seed_from_csv(file) }
  end

  private

  def seed_from_csv(file)
    csv_zcta_text = File.read(file)
    csv_zctas     = CSV.parse(csv_zcta_text, headers: true, encoding: 'ISO-8859-1')
    csv_zctas.each { |row| import_row(row) }
  end

  def import_row(row)
    state_abbr = State.find_by(state_code: row['STATE']).abbr
    district   = District.find_by(full_code: row['STATE'] + row['DISTRICT'])
    zcta       = Zcta.find_or_create_by(zcta: row['ZCTA'])
    add_zcta_district(district, state_abbr, zcta, row['ZCTA']) unless district.blank?
  end

  def add_zcta_district(district, state_abbr, zcta, zip_code)
    ZctaDistrict.create(
      zip_code: zip_code,
      district_code:     district.code,
      state:             state_abbr,
      district:          district,
      zcta:              zcta
    )
    puts "Added district #{district.code} to ZCTA #{zip_code}"
  end
end
