# frozen_string_literal: true

class GeoLookup
  # Address value from params.
  attr_accessor :address
  # Lat/lon coordinates taken from params request, or geocoded from :address.
  attr_accessor :coordinates
  # The State that the :district belongs to.
  attr_accessor :state
  # Voting district found by a GIS database query to find the geometry that
  # contains the :coordinates.
  attr_accessor :district
  # Rep records that are associated to the district and state.
  attr_accessor :reps
  # OfficeLocation records that are associated to the district and state.
  attr_accessor :office_locations
  # Radius of the lookup for office_locations
  attr_accessor :radius

  def initialize(address: nil, lat: nil, long: nil, radius: nil)
    self.coordinates = [lat.to_f, long.to_f] - [0.0]
    self.address = address
    self.radius  = radius
    find_coordinates_by_address if coordinates.blank? && address
    find_district_and_state unless coordinates.blank?
  end

  # Find the reps in the db associated to location, and sort the offices by distance.
  def find_reps
    return Rep.none if district.blank?
    self.reps = Rep.by_location(state: state, district: district).includes(:office_locations)
    reps.each { |rep| rep.sort_offices(coordinates) }
  end

  def find_office_locations
    return OfficeLocation.none if district.blank?
    self.office_locations = OfficeLocation.active.near coordinates, radius
    office_locations.each { |off| off.calculate_distance coordinates }
  end

  private

  # Geocode address into [lat, lon] coordinates.
  def find_coordinates_by_address
    self.coordinates = Geocoder.coordinates(address)
  end

  # Find the district geometry that contains the coordinates,
  # and the district and state it belongs to.
  def find_district_and_state
    lat           = coordinates.first
    lon           = coordinates.last
    district_geom = DistrictGeom.containing_latlon(lat, lon).includes(district: :state).take
    return if district_geom.blank?
    self.district = district_geom.district
    self.state    = district.state
  end
end
