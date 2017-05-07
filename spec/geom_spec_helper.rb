# frozen_string_literal: true

class GeomSpecHelper
  def self.nebraska_geometry
    @nebraska_geometry ||= RGeo::Shapefile::Reader.open(
      shapefile, factory: Geographic::FACTORY, assume_inner_follows_outer: true
    ) do |file|
      file.each do |record|
        next unless record.attributes['NAME'] == 'Nebraska'
        record.geometry.projection.each do |poly|
          return poly
        end
      end
    end
  end

  def self.shapefile
    Rails.root.join(
      'lib', 'shapefiles', 'us_states_122116', 'cb_2015_us_state_500k.shp'
    )
  end
end
