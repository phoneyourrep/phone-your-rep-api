# frozen_string_literal: true

class Coordinates
  include Enumerable

  attr_reader :latlon

  def initialize(latlon: nil, lat: 0.0, long: 0.0, address: '')
    @latlon = latlon ? Array(latlon).map(&:to_f) : [lat.to_f, long.to_f] - [0.0]
    @latlon = Array(Geocoder.coordinates(address)) if @latlon.empty?
  end

  def each(&block)
    latlon.each(&block)
  end

  def last
    latlon.last
  end

  def [](index)
    latlon[index]
  end

  def lat
    latlon[0]
  end

  def lon
    latlon[1]
  end

  def empty?
    latlon.empty?
  end

  def blank?
    latlon.blank?
  end

  def districts
    @_districts ||= if latlon.empty?
                      NullObject.new
                    else
                      {
                        congress: district_geom.district,
                        state_lower: state_lower_district_geom.state_district,
                        state_upper: state_upper_district_geom.state_district
                      }
                    end
  end

  def district_geom
    @_district_geom ||= begin
      DistrictGeom.containing_latlon(lat, lon).includes(district: :state).take || NullObject.new
    end
  end

  def state_district_geoms
    @_state_district_geoms ||= begin
      StateDistrictGeom.containing_latlon(lat, lon).includes(:state_district) || NullObject.new
    end
  end

  def state_lower_district_geom
    state_district_geoms.lower.take || NullObject.new
  end

  def state_upper_district_geom
    state_district_geoms.upper.take || NullObject.new
  end

  def state
    raise StandardError, 'Districts found have mismatching states' if mismatching_states?
    @_state ||= districts[:congress].state
  end

  def mismatching_states?
    if !districts[:state_upper].blank? &&
       districts[:congress].state != districts[:state_upper].state
      true
    else
      false
    end
  end
end
