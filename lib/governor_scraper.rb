# frozen_string_literal: true

require 'governor_scraper/bio_page'
require 'governor_scraper/name_parser'
require 'governor_scraper/panel'

class GovernorScraper
  BASE_URI = 'https://www.nga.org'
  CONN = Faraday.new(url: BASE_URI)

  def self.governors
    @_governors ||= []
  end

  def self.index_page
    @_index_page ||= Nokogiri::HTML(CONN.get('/cms/governors/bios').body)
  end

  def self.panels
    @_panels ||= index_page.css('.panel.panel-default.governors').map do |panel|
      Panel.new(panel)
    end
  end

  def self.scrape
    governors.clear
    panels.each do |panel|
      governor = create(panel)
      puts "Scraped #{governor.official_full} of #{governor.state_name}"
    end
  end

  def self.create(panel)
    new(panel).tap do |g|
      g.build
      g.save
    end
  end

  def self.to_json
    governors.map(&:to_h)
  end

  attr_reader :panel, :state_name, :bio_page, :official_full, :first, :last,
              :middle, :nickname, :suffix, :url, :party, :office_locations

  def initialize(panel)
    @panel = panel
  end

  def build
    @bio_page      = BioPage.new(panel.bio_page)
    @state_name    = panel.state
    @official_full = panel.governor_name
    @url           = bio_page.website
    @party         = bio_page.party

    @first, @last, @middle, @nickname, @suffix = NameParser.new(official_full).parse
    build_office_locations
    self
  end

  def photo_url
    @_photo_url ||= "#{BASE_URI}#{panel.image}"
  end

  def build_office_locations
    @office_locations = [primary_office]
    @office_locations << secondary_office if bio_page.alt_office_present?
  end

  def primary_office
    { address: bio_page.address, city: bio_page.city, state: bio_page.state, zip: bio_page.zip,
      phone: bio_page.phone, fax: bio_page.fax, office_type: bio_page.office_type }
  end

  def secondary_office
    { address: bio_page.alt_address, city: bio_page.alt_city, state: bio_page.alt_state,
      zip: bio_page.alt_zip, phone: bio_page.alt_phone, fax: bio_page.alt_fax,
      office_type: bio_page.alt_office_type }
  end

  def save
    self.class.governors << self
    self
  end

  def to_h
    {
      photo_url: photo_url,
      state_name: state_name,
      official_full: official_full,
      url: url,
      party: party,
      office_locations: office_locations
    }
  end

  def inspect
    "#<GovernorScraper panel=#{panel} photo_url=\"#{photo_url}\" "\
      "state_name=\"#{state_name}\" bio_page=#{bio_page} "\
      "official_full=\"#{official_full}\" url=\"#{url}\" "\
      "party=\"#{party}\" office_locations=\"#{office_locations}\">"
  end
end
