# frozen_string_literal: true
module VCardable
  def make_v_card
    Vpim::Vcard::Maker.make2 do |maker|
      add_rep_name(maker)
      add_rep_photo(maker)
      add_contact_url(maker)
      add_primary_phone(maker)
      add_primary_address(maker)
      add_secondary_office(maker)
      maker.org = rep.role
    end
  end

  def add_secondary_office(maker)
    rep.office_locations.each do |office|
      next if office.office_type == office_type
      add_secondary_address(maker, office)
      add_secondary_phone(maker, office)
      break
    end
  end

  def add_secondary_phone(maker, office)
    return if office.phone.blank?
    maker.add_tel(office.phone) do |tel|
      tel.preferred  = false
      tel.location   = 'work'
      tel.capability = 'voice'
    end
  end

  def add_secondary_address(maker, office)
    maker.add_addr do |addr|
      addr.preferred  = false
      addr.location   = 'work'
      addr.street     = office.suite ? "#{office.address}, #{office.suite}" : office.address
      addr.locality   = office.city
      addr.region     = office.state
      addr.postalcode = office.zip
    end
  end

  def add_primary_address(maker)
    maker.add_addr do |addr|
      addr.preferred  = true
      addr.location   = 'work'
      addr.street     = suite ? "#{address}, #{suite}" : address
      addr.locality   = city
      addr.region     = state
      addr.postalcode = zip
    end
  end

  def add_contact_url(maker)
    if rep.contact_form
      maker.add_url(rep.contact_form)
    elsif rep.url
      maker.add_url(rep.url)
    end
  end

  def add_primary_phone(maker)
    return if phone.blank?
    maker.add_tel(phone) do |tel|
      tel.preferred  = true
      tel.location   = 'work'
      tel.capability = 'voice'
    end
  end

  def add_rep_name(maker)
    maker.add_name do |name|
      name.prefix   = ''
      name.fullname = rep.official_full if rep.official_full
      name.given    = rep.first if rep.first
      name.family   = rep.last if rep.last
      name.suffix   = rep.suffix if rep.suffix
    end
  end

  def add_rep_photo(maker)
    begin
      web_photo = open(rep.photo) { |f| f.read }
    rescue OpenURI::HTTPError => e
      logger.error e
    end
    if web_photo
      maker.add_photo do |photo|
        photo.image = web_photo
        photo.type  = 'JPEG'
      end
    end
  end
end
