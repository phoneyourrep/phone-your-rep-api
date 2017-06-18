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
                        congress: find_district_geom.district,
                        state: find_state_district_geom.state_district
                      }
                    end
  end

  def find_district_geom
    DistrictGeom.containing_latlon(lat, lon).includes(district: :state).take || NullObject.new
  end

  def find_state_district_geom
    StateDistrictGeom.containing_latlon(lat, lon).includes(:state_district).take || NullObject.new
  end

  def state
    raise StandardError, 'Districts found have mismatching states' if mismatching_states?
    @_state ||= districts[:congress].state
  end

  def mismatching_states?
    if !districts[:state].blank? && districts[:congress].state != districts[:state].state
      true
    else
      false
    end
  end
end
