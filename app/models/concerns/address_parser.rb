# frozen_string_literal: true

module AddressParser
  def nbsp
    Nokogiri::HTML('&nbsp;').text
  end

  def extract_zip_from_full_address
    self.zip = address.match(/(\p{Zs}|\s)+\d{5}(?:[-\s]\d{4})?(\s+)?\z/).to_s
    address.sub!(zip, '')
    zip.delete!("\n ,#{nbsp}")
  end

  def extract_state_from_full_address
    self.state = address.match(/\s+[A-Z]{2}(\s|,)?\z/).to_s
    address.sub!(state, '')
    state.delete!("\n ,#{nbsp}")
  end

  def trim_address_tail
    trim = address.match(/[A-Za-z\s\p{Zs}]+\z/)
    address.sub!(trim.to_s, '') unless trim.to_s == "\n"
  end

  def add_fields_for_phone_only(phone_only)
    address.sub!(phone_only.to_s, '')
    self.city    = address
    self.state   = rep.state.abbr
    self.address = ''
    geocode
    reverse_geocode
  end

  def split_city_on_digits
    split_city_on_digits = city&.split(/\d/)
    return if split_city_on_digits.blank?
    address << city&.sub(split_city_on_digits.last, '')&.strip
    self.city = split_city_on_digits.last.strip
  end

  def extract_building
    match = address.match(/\A(\w|\W)+(B|b)uilding\s/)
    return unless match
    self.building = match.to_s.strip
    address.sub!(match.to_s, '').strip!
  end

  def extract_suite
    match = address.match(/(Annex\s)?([Rr](oo)?m|[Ss](ui)?te)\.?\s\w+(-\w+)?/)
    return unless match
    self.suite = match.to_s.strip
    address.sub!(match.to_s, '').strip!
  end

  def set_city_state_and_zip
    return unless address_changed?
    phone_only = address.match(/[\p{Zs}\s]+Phone(\s?)+\z/)
    return add_fields_for_phone_only(phone_only) if phone_only
    trim_address_tail
    extract_zip_from_full_address
    extract_state_from_full_address

    address_array = address.gsub("\n", ', ').split(', ')
    self.city     = address_array.pop&.delete(",\n#{nbsp}")
    self.address  = address_array.join("\n")

    split_city_on_digits
    extract_building
    extract_suite
  end
end
