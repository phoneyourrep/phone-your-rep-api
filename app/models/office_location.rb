# frozen_string_literal: true

class OfficeLocation < ApplicationRecord
  # Set a "PYR_S3_BUCKET" environment variable to your own S3 Bucket
  # if you want to use your own generated QR Codes.
  S3_BUCKET = ENV['PYR_S3_BUCKET'] || 'phone-your-rep-images'

  belongs_to :rep, foreign_key: :bioguide_id, primary_key: :bioguide_id
  has_one    :v_card, dependent: :destroy
  has_many   :issues

  geocoded_by :full_address

  after_validation :geocode, if: :needs_geocoding?

  scope :active, -> { where(active: true) }

  scope :with_v_card, ->(office_id) { where(office_id: office_id).includes(:rep, :v_card) }

  scope :sorted_by_distance, ->(coordinates) { near(coordinates, 4000) }

  scope :capitol, -> { where office_type: 'capitol' }

  scope :district, -> { where office_type: 'district' }

  is_impressionable counter_cache: true, column_name: :downloads

  dragonfly_accessor :qr_code

  attr_reader :distance

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

  def add_v_card
    v_card = VCard.find_or_create_by(office_location_id: id)
    v_card.data = make_v_card.to_s
    update_attribute :v_card, v_card
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
