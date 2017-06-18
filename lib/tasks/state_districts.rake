# frozen_string_literal: true

require_relative '../state_district_exporter'

namespace :pyr do
  namespace :state_districts do
    desc 'Export State District metadata from shapefiles to CSV'
    task :export do
      StateDistrictExporter.call
    end

    desc 'Import State District metadata from CSV to database'
    task :import do
      StateDistrictImporter.call
    end
  end
end
