# frozen_string_literal: true

class Rep < ApplicationRecord
  include HasOfficialID
  include HasLevel
  include HasChamber

  belongs_to :district
  belongs_to :state
  has_many   :office_locations,
             dependent: :destroy,
             foreign_key: :official_id,
             primary_key: :official_id
  has_many   :active_office_locations,
             -> { where(active: true) },
             class_name: 'OfficeLocation',
             foreign_key: :official_id,
             primary_key: :official_id

  scope :by_location, lambda { |state:, district:|
    where(district: district).or(Rep.where(state: state, district: nil)).active.distinct
  }

  scope :active, lambda {
    where(active: true).includes(:district, :state, :active_office_locations)
  }

  scope :legislators, -> { where.not type: 'Governor' }

  scope :governors, -> { where type: 'Governor' }

  scope :republican, -> { where party: 'Republican' }

  scope :democrat, -> { where party: 'Democrat' }

  scope :independent, -> { where party: 'Independent' }

  scope :last_name, ->(last) { where 'last ILIKE ?', "%#{last}%" }

  scope :official_ids, lambda { |ids|
    ids = ids.is_a?(String) ? ids.split(',') : ids
    where official_id: ids
  }

  scope :state, lambda { |name|
    joins(:state).
      where(states: { name: name.capitalize }).
      or(joins(:state).where(states: { abbr: name.upcase }))
  }

  scope :district, lambda { |code|
    joins(:district).
      where(districts: { code: code }).
      or(joins(:district).where(districts: { full_code: code }))
  }

  scope :party, ->(name) { where party: name.capitalize }

  def self.official_ids_and_names
    all.
      select(:official_full, :official_id).
      pluck(:official_full, :official_id).
      map { |a| { official_full: a.first, official_id: a.last } if a.first.present? }.
      compact
  end

  before_save :set_level, :set_official_id

  serialize :committees, Array

  is_impressionable

  # Instance attribute that holds offices sorted by location after calling the :sort_offices method.
  attr_writer :sorted_offices

  # Sort the offices by proximity to the request coordinates,
  # making sure to not miss offices that aren't geocoded.
  def sort_offices(coordinates)
    self.sorted_offices = active_office_locations.sorted_by_distance(coordinates)
    sorted_offices.each { |office| office.calculate_distance(coordinates) }
  end

  # Protect against nil type errors.
  def district_code
    district.try(:code)
  end

  # Return office_locations even if they were never sorted.
  def sorted_offices
    @sorted_offices ||= active_office_locations.order(:office_id)
  end

  def add_photo
    update photo: fetch_photo_data ? photo_url : nil
  end

  def fetch_photo_data
    open(photo_url, &:read) unless photo_url.blank?
  rescue OpenURI::HTTPError => e
    logger.error e
    false
  rescue URI::InvalidURIError => e
    logger.error e
    false
  rescue OpenSSL::SSL::SSLError => e
    logger.error e
    e.message
  rescue Encoding::UndefinedConversionError => e
    logger.error e
    e.message
  end
end
