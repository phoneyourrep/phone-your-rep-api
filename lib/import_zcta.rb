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

  def zcta_code(row)
    zcta5 = row['ZCTA5']
    case zcta5.size
    when 4
      '0' + zcta5
    when 3
      '00' + zcta5
    when 2
      '000' + zcta5
    else
      zcta5
    end
  end

  def seed_from_csv(file)
    csv_zcta_text = File.read(file)
    csv_zctas     = CSV.parse(csv_zcta_text, headers: true, encoding: 'ISO-8859-1')
    csv_zctas.each { |row| import_row(row) }
  end

  def import_row(row)
    state_code = row['STATE'].size == 1 ? '0' + row['STATE'] : row['STATE']
    dis_cod    = row['CD'].size == 1 ? '0' + row['CD'] : row['CD']
    zcta_code  = zcta_code(row)
    state_abbr = State.find_by(state_code: state_code).abbr
    district   = District.find_by(full_code: state_code + dis_cod)
    zcta       = Zcta.find_or_create_by(zcta: zcta_code)
    add_zcta_district(district, state_abbr, zcta, zcta_code) unless district.blank?
  end

  def add_zcta_district(district, state_abbr, zcta, zcta_code)
    ZctaDistrict.create(
      zip_code: zcta_code,
      district_code:     district.code,
      state:             state_abbr,
      district:          district,
      zcta:              zcta
    )
    puts "Added district #{district.code} to ZCTA #{zcta_code}"
  end
end
