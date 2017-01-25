class DistrictGeom < ApplicationRecord
  belongs_to :district, foreign_key: :full_code, primary_key: :full_code

  FACTORY = RGeo::Geographic.simple_mercator_factory
  EWKB = RGeo::WKRep::WKBGenerator.new(type_format:    :ewkb,
                                       emit_ewkb_srid: true,
                                       hex_format:     true)

  def self.containing_latlon(lat, lon)
    ewkb = EWKB.generate(FACTORY.point(lon, lat).projection)
    where("ST_Intersects(geom, ST_GeomFromEWKB(E'\\\\x#{ewkb}'))").includes(:district)
  end

  def self.containing_point(point)
    ewkb = EWKB.generate(point.projection)
    where("ST_Intersects(geom, ST_GeomFromEWKB(E'\\\\x#{ewkb}'))")
  end

  def contains?(point)
    point.within?(geom)
  end
end
