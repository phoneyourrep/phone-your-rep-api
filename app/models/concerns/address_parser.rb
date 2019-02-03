# frozen_string_literal: true

module AddressParser
  def nbsp
    Nokogiri::HTML('&nbsp;').text
  end

  def set_city_state_and_zip
    return unless address && address_changed?
    phone_only = address.match(/[\p{Zs}\s]+Phone(\s?)+\z/)
    return add_fields_for_phone_only(phone_only) if phone_only
    trim_address_tail
    extract_zip_and_state_from_full_address

    address_array = address.gsub("\n", ', ').split(', ')
    address_array.length <= 1 ? geocode_city : extract_city_from_address_array(address_array)

    extract_building_and_suite
    self.address = nil if address.blank?
  end

  def add_fields_for_phone_only(phone_only)
    address.sub!(phone_only.to_s, '')
    self.city    = address
    self.state   = rep.state.abbr
    self.address = ''
    geocode
    reverse_geocode
  end

  def trim_address_tail
    trim = address.match(/[A-Za-z\s\p{Zs}]+\z/)
    address.sub!(trim.to_s, '') unless trim.to_s == "\n"
  end

  def extract_zip_and_state_from_full_address
    extract_zip_from_full_address
    extract_state_from_full_address
  end

  def extract_zip_from_full_address
    self.zip = address.match(/(\p{Zs}|\s)+\d{5}(?:[-\s]\d{4})?(\s+)?\z/).to_s
    address.sub!(zip, '')
    zip.delete!("\n ,#{nbsp}")
  end

  def extract_state_from_full_address
    self.state = address.match(/,?\s+[A-Z]{2}(\s|,)?\z/).to_s
    address.sub!(state, '')
    state.delete!("\n ,#{nbsp}")
  end

  def split_city_on_digits
    split_city_on_digits = city&.split(/\d/)
    return if split_city_on_digits.blank?
    address << city&.sub(split_city_on_digits.last, '')&.strip
    self.city = split_city_on_digits.last.strip
  end

  def extract_building_or_suite(attribute, regex)
    match = address.match(regex)
    return unless match
    send "#{attribute}=", match.to_s.strip
    address.sub!(match.to_s, '').strip!
  end

  def extract_city_from_address_array(address_array)
    self.city    = address_array.pop&.delete(",\n#{nbsp}")
    self.address = address_array.join("\n")
    split_city_on_digits
  end

  def geocode_city
    geo = Geocoder.search("#{address}#{state}#{zip}").first
    self.city = geo&.city
    return if city.blank?
    address&.sub!(city, '')&.strip!
  end

  def extract_building_and_suite
    extract_building_or_suite :building, /\A[\w\W]+[Bb]uilding\s?/
    extract_building_or_suite :suite, /(Annex\s)?([Rr](oo)?m|[Ss](ui)?te)\.?\s\w+(-\w+)?/
  end
end
