# frozen_string_literal: true

# Export State Legislative District metadata from shapefile attributes to CSV
class StateDistrictExporter
  attr_accessor :csv_filename, :csv_data, :shapefile

  def self.call
    state_district_shapefiles.each do |shapefile|
      exporter = self.new(shapefile)
      exporter.export
    end
  end

  def self.state_district_shapefiles
    Dir.glob(Rails.root.join('lib/shapefiles/state_legislative_districts/*/*/*.shp'))
  end

  def initialize(shapefile)
    self.shapefile = shapefile
    self.csv_filename = if shapefile.match?(/sldu/)
      'upper.csv'
    else
      'lower.csv'
    end
  end

  def export
    csv_data = generate_csv_data
    Dir.mkdir(target_dir) unless Dir.exist?(target_dir)
    Dir.chdir(target_dir) do
      File.open(csv_filename, 'w') { |file| file.write csv_data }
    end
  end

  private

  def state_name
    @_state_name ||= shapefile.split('/')[-3]
  end

  def target_dir
    @_target_dir ||= Rails.root.join('lib/seeds/state_leg_districts', state_name).to_s
  end

  def generate_csv_data
    CSV.generate do |csv|
      csv << %w[state_code code full_code name]
      RGeo::Shapefile::Reader.open(shapefile, factory: Geographic::FACTORY) do |file|
        puts "File contains #{file.num_records} records."
        file.each do |record|
          csv << extract_data_from_shapefile(record)
        end
      end
    end
  end

  def extract_data_from_shapefile(record)
    short_code = if csv_filename == 'upper.csv'
      record.attributes['SLDUST']
    else
      record.attributes['SLDLST']
    end

    [
      record.attributes['STATEFP'],
      short_code,
      record.attributes['GEOID'],
      record.attributes['NAME']
    ]
  end
end
