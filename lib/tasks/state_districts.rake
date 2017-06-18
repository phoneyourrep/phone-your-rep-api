# frozen_string_literal: true

require_relative '../state_district_exporter'

namespace :pyr do
  namespace :state_districts do
    desc 'Export State District metadata from shapefiles to CSV'
    task :export do
      StateDistrictExporter.to_csv
    end

    desc 'Import State District metadata from CSV to database'
    task :import do
      StateDistrictImporter.call
    end

    desc 'Load State District shapefiles into the database'
    task :load_shapefiles do
      StateDistrictExporter.geoms_to_database
    end
  end
end
