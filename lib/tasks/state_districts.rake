# frozen_string_literal: true

require_relative '../state_district_exporter'

namespace :pyr do
  namespace :state_districts do
    desc 'Export State District metadata from shapefiles to CSV'
    task :to_csv_from_shapefile do
      StateDistrictExporter::Shapefile.to_csv
    end

    desc 'Export State District metadata from database to CSV'
    task :to_csv_from_database do
      StateDistrictExporter::Database.to_csv
    end

    desc 'Import State District metadata from CSV to database'
    task :import do
      StateDistrictImporter.call
    end

    desc 'Load State District shapefiles into the database'
    task :load_shapefiles do
      StateDistrictExporter::Shapefile.geoms_to_database
    end
  end
end
