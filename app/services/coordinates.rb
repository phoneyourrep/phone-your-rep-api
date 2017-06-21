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
                        congress: congressional_district,
                        state_lower: state_lower_district,
                        state_upper: state_upper_district
                      }
                    end
  end

  def district_geoms
    @_district_geoms ||= begin
      DistrictGeom.containing_latlon(lat, lon).includes(district: :state) || NullObject.new
    end
  end

  def congressional_district_geom
    @_congressional_district_geom ||= district_geoms.detect do |dis_geom|
      dis_geom.type == 'CongressionalDistrictGeom'
    end
  end

  def state_district_geoms
    @_state_district_geoms ||= district_geoms.select do |dis_geom|
      dis_geom.type == 'StateDistrictGeom'
    end
  end

  def state_lower_district_geom
    state_district_geoms.detect { |d| d.chamber == 'lower' }
  end

  def state_upper_district_geom
    state_district_geoms.detect { |d| d.chamber == 'upper' }
  end

  def congressional_district
    @_congressional_district ||= congressional_district_geom&.district
  end

  def state_lower_district
    @_state_lower_district ||= state_lower_district_geom&.district
  end

  def state_upper_district
    @_state_upper_district ||= state_upper_district_geom&.district
  end

  def state
    raise StandardError, 'Districts found have mismatching states' if mismatching_states?
    @_state ||= districts[:congress]&.state
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
