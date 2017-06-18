# frozen_string_literal: true

require_relative '../config/environment.rb'

# Export State Legislative District metadata from shapefile attributes to CSV
class StateDistrictExporter
  attr_accessor :shapefile

  def self.to_csv
    export(:export_to_csv)
  end

  def self.geoms_to_database
    StateDistrictGeom.destroy_all
    export(:load_geoms_into_database)
  end

  def self.export(symbol)
    state_district_shapefiles.each do |shapefile|
      exporter = new(shapefile)
      exporter.send(symbol)
    end
  end

  def self.state_district_shapefiles
    Dir.glob(Rails.root.join('lib/shapefiles/state_legislative_districts/*/*/*.shp'))
  end

  def initialize(shapefile)
    self.shapefile = shapefile
  end

  private

  def export_to_csv
    csv_data = generate_csv_data
    Dir.mkdir(csv_target_dir) unless Dir.exist?(csv_target_dir)
    Dir.chdir(csv_target_dir) do
      File.open(csv_filename, 'w') { |file| file.write csv_data }
    end
  end

  def load_geoms_into_database
    RGeo::Shapefile::Reader.open(shapefile, factory: Geographic::FACTORY) do |file|
      puts "Filecontains #{file.num_records} records."
      file.each do |record|
        puts "Record number #{record.index}:"
        record.geometry.projection.each do |poly|
          StateDistrictGeom.create(
            full_code: full_code(record),
            geom: poly
          )
        end
        puts record.attributes
      end
    end
  end

  def state_name
    @_state_name ||= shapefile.split('/')[-3]
  end

  def csv_target_dir
    @_csv_target_dir ||= Rails.root.join('lib/seeds/state_leg_districts', state_name).to_s
  end

  def generate_csv_data
    CSV.generate do |csv|
      csv << %w[state_code code full_code name chamber]
      RGeo::Shapefile::Reader.open(shapefile, factory: Geographic::FACTORY) do |file|
        puts "File contains #{file.num_records} records."
        file.each do |record|
          csv << extract_csv_data_from_shapefile(record)
        end
      end
    end
  end

  def extract_csv_data_from_shapefile(record)
    [
      record.attributes['STATEFP'],
      short_code(record),
      full_code(record),
      record.attributes['NAME'],
      chamber
    ]
  end

  def short_code(record)
    if chamber == 'upper'
      record.attributes['SLDUST']
    else
      record.attributes['SLDLST']
    end
  end

  def full_code(record)
    "#{record.attributes['GEOID']}-#{chamber}"
  end

  def chamber
    @_chamber ||= if shapefile.match?(/sldu/)
                    'upper'
                  else
                    'lower'
                  end
  end

  def csv_filename
    @_csv_filename ||= "#{chamber}.csv"
  end
end
