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
    self.address     = address.to_s
    self.radius      = radius.to_f
    self.coordinates = Coordinates.new(lat: lat, long: long, address: self.address)
    self.district    = coordinates.find_district
    self.state       = district.state
  end

  # Find the reps in the db associated to location, and sort the offices by distance.
  def find_reps
    return Rep.none if district.blank?
    self.reps = Rep.by_location(state: state, district: district).includes(:office_locations)
  end

  def find_office_locations
    return OfficeLocation.none if coordinates.latlon.empty?
    self.office_locations = OfficeLocation.active.near coordinates.latlon, radius
  end
end
