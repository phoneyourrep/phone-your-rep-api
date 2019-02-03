# frozen_string_literal: true

class GeoRepRepresenter
  METHODS = %i[
    id 
    district_id
    state_id
    role
    official_full
    last
    first
    middle
    suffix
    party
    contact_form
    url
    twitter
    facebook
    youtube
    googleplus
    committees
    senate_class
    bioguide_id
    photo
    created_at
    updated_at
    nickname
    instagram
    instagram_id
    facebook_id
    youtube_id
    twitter_id
    active
    type
    chamber
    state_leg_id
    photo_url
    level
    official_id
    state
    district
    sort_offices
    sorted_offices
  ].freeze

  delegate *METHODS, to: :rep

  attr_reader :rep, :coordinates

  def initialize(rep, coordinates)
    @rep = rep
    @coordinates = coordinates
  end

  def active_office_locations
    @active_office_locations ||= sort_offices(coordinates)
  end
end
