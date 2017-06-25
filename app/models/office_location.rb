# frozen_string_literal: true

class OfficeLocation < ApplicationRecord
  include HasOfficialID
  include HasLevel

  # Set a "PYR_S3_BUCKET" environment variable to your own S3 Bucket
  # if you want to use your own generated QR Codes.
  S3_BUCKET = ENV['PYR_S3_BUCKET'] || 'phone-your-rep-images'

  belongs_to :rep, foreign_key: :official_id, primary_key: :official_id
  has_many   :issues

  geocoded_by :geocoder_address

  validates :rep, presence: true

  after_validation :geocode, if: :needs_geocoding?

  reverse_geocoded_by :latitude, :longitude do |obj, results|
    geo = results.first
    obj.state = geo.state_code if geo
  end

  after_validation :reverse_geocode, if: -> { state.blank? }

  before_save :set_official_id, :set_bioguide_or_state_leg_id, :set_office_id, :set_level

  before_save :set_city_state_and_zip, if: -> { rep.type == 'StateRep' && !address.blank? }

  scope :active, -> { where(active: true) }

  scope :sorted_by_distance, ->(coordinates) { near(coordinates, 4000) }

  scope :capitol, -> { where office_type: 'capitol' }

  scope :district, -> { where office_type: 'district' }

  is_impressionable counter_cache: true, column_name: :downloads

  dragonfly_accessor :qr_code

  attr_reader :distance

  def set_city_state_and_zip
    extract_zip_from_full_address
    extract_state_from_full_address

    address_array = address.gsub("\n", ', ').split(', ')
    self.city     = address_array.pop.delete(',')
    self.address  = address_array.join("\n")
  end

  def extract_state_from_full_address
    self.state = address.match(/\s[A-Z]{2}(\s|,)?\z/).to_s
    address.sub!(state, '')
    state.delete!("\n ,")
  end

  def extract_zip_from_full_address
    self.zip = address.match(/\s\d{5}(?:[-\s]\d{4})?$\z/).to_s
    address.sub!(zip, '')
    zip.delete!("\n ,")
  end

  def set_office_id
    return unless office_id.blank?
    self.office_id = if office_type == 'capitol'
                       "#{official_id}-capitol"
                     elsif rep.is_a?(StateRep)
                       "#{official_id}-#{office_type}"
                     else
                       "#{official_id}-#{city}"
                     end
  end

  def set_bioguide_or_state_leg_id
    if rep.is_a?(CongressionalRep) && bioguide_id.blank?
      self.bioguide_id = official_id
    elsif rep.is_a?(StateRep) && state_leg_id.blank?
      self.state_leg_id = official_id
    end
  end

  def needs_geocoding?
    latitude.blank? || longitude.blank?
  end

  def add_qr_code_img
    self.qr_code = RQRCode::QRCode.new(
      make_v_card(photo: false).to_s,
      size: 28,
      level: :h
    ).as_png(size: 360).to_string
    qr_code.name = "#{office_id}.png"
    save
  end

  def make_v_card(photo: true)
    v_card_builder = VCardBuilder.new self, rep
    v_card_builder.make_v_card(photo: photo)
  end

  def full_address
    "#{address}, #{city_state_zip}"
  end

  def city_state_zip
    [city, state, zip].join(' ')
  end

  def geocoder_address
    if rep.is_a?(Governor)
      city_state_zip
    else
      full_address
    end
  end

  def calculate_distance(coordinates)
    return if needs_geocoding?
    @distance = Geocoder::Calculations.distance_between(coordinates, [latitude, longitude]).round(1)
  end

  def v_card_link
    if Rails.env.production?
      "https://phone-your-rep.herokuapp.com/v_cards/#{office_id}"
    else
      "http://localhost:3000/v_cards/#{office_id}"
    end
  end

  def qr_code_link
    return unless office_id
    "https://s3.amazonaws.com/#{S3_BUCKET}/#{office_id.tr('-', '_')}.png"
  end
end
