# frozen_string_literal: true

# Scrapes data from OpenStates.org and loads into the database
class StateRepUpdater
  STATE_ABBREVIATIONS = %w[AL AK AZ AR CA CO CT DE DC FL GA HI ID IL
                           IN IA KS KY LA ME MD MA MI MN MS MO MT NE
                           NV NH NJ NM NY NC ND OH OK OR PA PR RI SC
                           SD TN TX UT VT VA WA WV WI WY].freeze

  attr_reader :state, :open_states_reps

  def self.update!
    STATE_ABBREVIATIONS.each do |state_abbr|
      open_states_reps = OpenStates.call(:legislators) { |r| r.state = state_abbr }.objects
      updater          = new(open_states_reps, state_abbr)

      updater.update!
    end
  end

  def initialize(open_states_reps, state_abbr)
    @state = State.find_by(abbr: state_abbr.upcase)
    @open_states_reps = open_states_reps
  end

  def update!
    open_states_reps.each do |os_rep|
      district = StateDistrict.find_by(state: state, name: os_rep.district, chamber: os_rep.chamber)
      next unless district
      add_or_update_rep(os_rep, district)
    end
  end

  def add_or_update_rep(os_rep, district)
    rep = StateRep.find_or_initialize_by(
      official_id: os_rep.leg_id, district: district, state: state
    )
    rep.official_full  = os_rep.full_name
    rep.last           = os_rep.last_name
    rep.first          = os_rep.first_name
    rep.middle         = os_rep.middle_name
    rep.party          = os_rep.party
    rep.contact_form   = os_rep.email
    rep.active         = os_rep.active
    rep.photo          = os_rep.photo_url
    rep.level          = os_rep.level
    rep.url            = os_rep.url
    rep.chamber        = os_rep.chamber
    rep.suffix         = os_rep.suffixes
    add_or_update_office_locations(rep, os_rep)
    rep.save
  end

  def add_or_update_office_locations(rep, os_rep)
    os_rep.offices.each do |os_off|
      off = rep.office_locations.find_or_initialize_by(
        office_type: os_off.type, rep: rep
      )
      off.fax     = os_off.fax     if os_off.fax
      off.phone   = os_off.phone   if os_off.phone
      off.address = os_off.address if os_off.address
    end
  end
end
