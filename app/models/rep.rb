# frozen_string_literal: true
class Rep < ApplicationRecord
  belongs_to :district
  belongs_to :state
  has_one    :avatar
  has_many   :office_locations, dependent: :destroy, foreign_key: :bioguide_id, primary_key: :bioguide_id
  scope      :yours, ->(state:, district:) {
    where(district: district).or(Rep.where(state: state, district: nil))
  }
  serialize  :committees, Array
  is_impressionable

  # Open up Rep Metaclass to set Class attributes --------------------------------------------------------------------
  class << self
    # Address value from params.
    attr_accessor :address
    # Lat/lon coordinates taken from params request, or geocoded from :address.
    attr_accessor :coordinates
    # The State that the :district belongs to.
    attr_accessor :state
    # Voting district found by a GIS database query to find the geometry that contains the :coordinates.
    attr_accessor :district
    # Rep records that are associated to the district and state.
    attr_accessor :reps
  end # Metaclass ----------------------------------------------------------------------------------------------------

  # Instance attribute that holds offices sorted by location after calling the :sort_offices method.
  attr_accessor :sorted_offices

  # Find the reps in the db associated to location, and sort the offices by distance.
  def self.find_em(address: nil, lat: nil, long: nil)
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
  def self.init(address, lat, long)
    self.reps        = nil
    self.coordinates = [lat.to_f, long.to_f] - [0.0]
    self.state       = nil
    self.address     = address
    return unless coordinates.blank?
    find_coordinates_by_address if address
  end

  # Geocode address into [lat, lon] coordinates.
  def self.find_coordinates_by_address
    self.coordinates = Geocoder.coordinates(address)
  end

  # Find the district geometry that contains the coordinates, and the district and state it belongs to.
  def self.find_district_and_state
    lat           = coordinates.first
    lon           = coordinates.last
    district_geom = DistrictGeom.containing_latlon(lat, lon).includes(district: :state).take
    return if district_geom.blank?
    self.district = district_geom.district
    self.state    = district.state
  end

  # Sort the offices by proximity to the request coordinates, making sure to not miss offices that aren't geocoded.
  def sort_offices(coordinates)
    closest_offices       = active_office_locations.near(coordinates, 4000)
    closest_offices      += active_office_locations
    self.sorted_offices   = closest_offices.uniq || []
    sorted_offices.blank? ? [] : sorted_offices.each { |office| office.calculate_distance(coordinates) }
  end

  # Return only active offices
  def active_office_locations
    office_locations.where(active: true)
  end

  # Protect against nil type errors.
  def district_code
    district.code unless district_id.blank?
  end

  # Return office_locations even if they were never sorted.
  def sorted_offices_array
    sorted_offices || office_locations
  end

  def add_photo
    update photo: photo_slug
  end

  def photo_slug
    "https://theunitedstates.io/images/congress/450x550/#{bioguide_id}.jpg"
  end

  def fetch_avatar_data
    ava = avatar || build_avatar
    ava.update data: open(photo) { |f| f.read }
  rescue => e
    logger.error e
  end
end
