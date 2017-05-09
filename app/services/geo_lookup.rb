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
  # Radius of the gem lookup for office_locations
  attr_accessor :radius

  def initialize(address: '', lat: 0.0, long: 0.0, radius: 0.0)
    self.coordinates = Coordinates.new(lat: lat, long: long)
    self.address = address.to_s
    self.radius  = radius.to_f
    find_coordinates_by_address if coordinates.empty?
    find_district_and_state
  end

  # Find the reps in the db associated to location, and sort the offices by distance.
  def find_reps
    return [] if district.blank?
    self.reps = Rep.by_location(state: state, district: district).includes(:office_locations)
    reps.each { |rep| rep.sort_offices(coordinates.latlon) }
  end

  def find_office_locations
    return [] if coordinates.latlon.empty?
    self.office_locations = OfficeLocation.active.near coordinates.latlon, radius
    office_locations.each { |off| off.calculate_distance coordinates.latlon }
  end

  private

  # Geocode address into [lat, lon] coordinates.
  def find_coordinates_by_address
    self.coordinates = Coordinates.new(latlon: Geocoder.coordinates(address))
  end

  # Find the district geometry that contains the coordinates,
  # and the district and state it belongs to.
  def find_district_and_state
    district_geom = coordinates.find_district_geom
    self.district = district_geom.district
    self.state    = district.state
  end
end
