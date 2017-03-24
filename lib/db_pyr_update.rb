# frozen_string_literal: true
require_relative '../config/environment'

module DbPyrUpdate
  class Base
    def initialize(file)
      @reps = YAML.load(File.open(file))
    end
  end

  class Reps < Base
    def call
      @reps.each do |yaml_rep|
        db_rep = Rep.find_or_create_by(bioguide_id: yaml_rep['id']['bioguide'])
        update_rep(db_rep, yaml_rep)
        puts "Updated #{db_rep.official_full}"
      end
    end

    private

    def update_rep(db_rep, yaml_rep)
      name = yaml_rep['name']
      term = yaml_rep['terms'].last
      db_rep.tap do |rep|
        update_rep_name(rep, name)
        update_rep_term_info(rep, term)
        update_rep_photo(rep)
        update_rep_capitol_office(rep, term)
        rep.active = true
      end
      db_rep.save
    end

    def update_rep_name(rep, name)
      rep.official_full = name['official_full']
      rep.first         = name['first']
      rep.middle        = name['middle']
      rep.last          = name['last']
      rep.suffix        = name['suffix']
      rep.nickname      = name['nickname']
    end

    def update_rep_term_info(rep, term)
      dis_code = format('%d', term['district']) if term['district']
      dis_code = dis_code.size == 1 ? "0#{dis_code}" : dis_code if dis_code
      rep.role = determine_current_rep_role(term)
      rep.state    = State.find_by(abbr: term['state'])
      rep.district = District.where(code: dis_code, state: rep.state).take
      rep.party         = term['party']
      rep.url           = term['url']
      rep.contact_form  = term['contact_form']
      rep.senate_class  = format('0%o', term['class']) if term['class']
    end

    def determine_current_rep_role(term)
      if term['type'] == 'sen'
        'United States Senator'
      elsif term['type'] == 'rep'
        'United States Representative'
      else
        term['type']
      end
    end

    def update_rep_capitol_office(rep, term)
      address_ary = term['address'].split(' ')
      cap_office  = OfficeLocation.find_or_create_by(
        office_type: 'capitol',
        bioguide_id: rep.bioguide_id
      )
      cap_office.tap do |off|
        update_basic_office_info(off, rep)
        update_phone_fax_and_hours(off, term)
        update_cap_office_address(address_ary, off)
      end
      cap_office.add_v_card
    end

    def update_basic_office_info(off, rep)
      off.office_id = "#{rep.bioguide_id}-capitol"
      off.rep       = rep
      off.active    = true
    end

    def update_phone_fax_and_hours(off, term)
      off.phone = term['phone']
      off.fax   = term['fax']
      off.hours = term['hours']
    end

    def update_cap_office_address(address_ary, off)
      off.zip     = address_ary.pop
      off.state   = address_ary.pop
      off.city    = address_ary.pop
      off.address = address_ary.
                    join(' ').
                    delete(';').
                    sub('HOB', 'House Office Building')
    end

    def update_rep_photo(rep)
      rep.add_photo
      rep.fetch_avatar_data
    end
    # End of private methods
  end

  class HistoricalReps < Base
    def call
      @reps.each do |h_rep|
        rep = Rep.find_by(bioguide_id: h_rep['id']['bioguide'])
        next if rep.blank?
        rep.update(active: false)
        rep.office_locations.each { |office| office.update(active: false) }
        puts "Retired #{rep.official_full}"
      end
    end
  end

  class Socials < Base
    def call
      @reps.each do |social|
        rep = Rep.find_or_create_by(bioguide_id: social['id']['bioguide'])
        update_rep_socials(rep, social)
        rep.save
        puts "Updated socials for #{rep.official_full}"
      end
    end

    private

    def update_rep_socials(rep, social)
      update_facebook(rep, social)
      update_twitter(rep, social)
      update_youtube(rep, social)
      update_instagram(rep, social)
      rep.googleplus   = social['social']['googleplus']
    end

    def update_instagram(rep, social)
      rep.instagram    = social['social']['instagram']
      rep.instagram_id = social['social']['instagram_id']
    end

    def update_youtube(rep, social)
      rep.youtube    = social['social']['youtube']
      rep.youtube_id = social['social']['youtube_id']
    end

    def update_twitter(rep, social)
      rep.twitter    = social['social']['twitter']
      rep.twitter_id = social['social']['twitter_id']
    end

    def update_facebook(rep, social)
      rep.facebook    = social['social']['facebook']
      rep.facebook_id = social['social']['facebook_id']
    end
    # End of private methods
  end

  class OfficeLocations < Base
    def call
      @active_offices = []
      @reps.each do |yaml_office|
        next if yaml_office['offices'].blank?
        find_or_create_offices(yaml_office)
      end
      district_offices = OfficeLocation.where(office_type: 'district').map(&:id)
      inactive_offices = district_offices - @active_offices
      OfficeLocation.find(inactive_offices).each { |o| o.update(active: false) }
    end

    private

    def find_or_create_offices(yaml_office)
      yaml_office['offices'].each do |yaml_off|
        office = OfficeLocation.find_or_create_by(
          bioguide_id: yaml_office['id']['bioguide'],
          office_id:   yaml_off['id'],
          office_type: 'district'
        )
        update_location_info(office, yaml_off)
        update_other_office_info(office, yaml_off)
        @active_offices << office.id
        puts "Updated #{office.rep.official_full}'s #{office.city} office"
      end
    end

    def update_location_info(office, yaml_off)
      office.office_id = yaml_off['id']
      office.suite     = yaml_off['suite']
      office.phone     = yaml_off['phone']
      office.address   = yaml_off['address']
      office.building  = yaml_off['building']
      office.city      = yaml_off['city']
      office.state     = yaml_off['state']
      office.zip       = yaml_off['zip']
      office.latitude  = yaml_off['latitude']
      office.longitude = yaml_off['longitude']
    end

    def update_other_office_info(office, yaml_off)
      office.fax    = yaml_off['fax']
      office.hours  = yaml_off['hours']
      office.active = true
      office.add_v_card
    end
    # End of private methods
  end
end
