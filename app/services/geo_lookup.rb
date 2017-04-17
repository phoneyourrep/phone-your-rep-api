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

  # Find the reps in the db associated to location, and sort the offices by distance.
  def find_em(address: nil, lat: nil, long: nil)
    init(address, lat, long)
    return [] if coordinates.blank?
    find_district_and_state
    return [] if district.blank?
    self.reps = Rep.yours(state: state, district: district).
        where(active: true).
        includes(:office_locations)
    self.reps = reps.distinct
    reps.each { |rep| rep.sort_offices(coordinates) }
  end

  # Reset attribute values, set the coordinates and address if available.
  def init(address, lat, long)
    self.reps        = nil
    self.state       = nil
    self.district    = nil
    self.coordinates = [lat.to_f, long.to_f] - [0.0]
    self.address     = address
    return unless coordinates.blank?
    find_coordinates_by_address if address
  end

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