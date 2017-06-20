# frozen_string_literal: true

require 'governor_scraper/page_scraper'

class GovernorScraper
  class BioPage < PageScraper
    attr_reader :uri

    def initialize(uri)
      @uri = uri
      @raw = Nokogiri::HTML(CONN.get(uri).body)
      check_for_alt_office
    end

    def check_for_alt_office
      @alt_office_present = if raw.css('address')[2].to_s.match?(/Phone|Address|Fax/)
                              true
                            else
                              false
                            end
    end

    def alt_office_present?
      @alt_office_present
    end

    def website
      @_website ||= raw.css('.ullist-wrap a').first['href']
    end

    def party_panel
      @_party_panel ||= if alt_office_present?
                          raw.css('address')[3]
                        else
                          raw.css('address')[2]
                        end
    end

    def party_paragraph
      @_party_paragraph ||= party_panel.css('p').detect do |p|
        p.text.include?('Party')
      end
    end

    def party
      @_party ||= party_paragraph.text.delete("\t\n#{nbsp}").sub('Party:', '')
    end

    def address_panel
      @_address_panel ||= raw.css('address')[1]
    end

    def address_array
      @_address_array ||=
          address_panel.css('p').first.text.delete("\t\n").sub('Address:', '').split(' ') - [' ']
    end

    def address
      @_address ||= address_array.join(' ')
    end

    def city
      @_city ||= address_panel.css('p')[1].text.delete(',')
    end

    def state
      @_state ||= address_panel.css('p')[2]&.text
    end

    def zip
      @_zip ||= address_panel.css('p')[3]&.text
    end

    def phone
      @_phone ||= address_panel.css('p')[4].text.delete("\t\nPhone: ").strip.sub('/', '-')
    end

    def fax
      @_fax ||= address_panel.css('p')[5]&.text&.delete("\t\nFax:")&.strip&.sub('/', '-')
    end

    def office_type
      'capitol'
    end

    def alt_address_panel
      @_alt_address_panel ||= raw.css('address')[2] if alt_office_present?
    end

    def alt_address_array
      if alt_office_present?
        @_alt_address_array ||=
            alt_address_panel.css('p').first.text.delete("\t\n").sub('Address:', '').split(' ') - [' ']
      end
    end

    def alt_building
      @_alt_building ||= alt_address_array[0..7].join(' ') if alt_office_present?
    end

    def alt_address
      @alt_address ||= alt_address_array[8..11].join(' ') if alt_office_present?
    end

    def alt_suite
      @alt_suite ||= alt_address_array[13..14].join(' ') if alt_office_present?
    end

    def alt_city
      @_alt_city ||= alt_address_panel.css('p')[1].text.delete(',') if alt_office_present?
    end

    def alt_state
      @_alt_state ||= alt_address_panel.css('p')[2].text if alt_office_present?
    end

    def alt_zip
      @_alt_zip ||= alt_address_panel.css('p')[3].text if alt_office_present?
    end

    def alt_phone
      if alt_office_present?
        @_alt_phone ||= alt_address_panel.css('p')[4].text.delete("\t\nPhone: ").strip.sub('/', '-')
      end
    end

    def alt_fax
      if alt_office_present?
        @_alt_fax ||= alt_address_panel.css('p')[5]&.text&.delete("\t\nFax:")&.strip&.sub('/', '-')
      end
    end

    def alt_office_type
      return unless alt_office_present?
      if alt_state == 'DC'
        'dc'
      else
        'district'
      end
    end
  end
end