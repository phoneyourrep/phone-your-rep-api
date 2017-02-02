module OpenStatesable
  def add_state_reps(coordinates)
    get_state_delegation(coordinates)
    @reps += instantiate_reps
  end

  def get_state_delegation(coordinates)
    @state_delegation = GetYourRep::OpenStates.all_reps coordinates
  end

  def instantiate_reps
    @state_delegation.map do |state_rep|
      Rep.new do |rep|
        rep.official_full = state_rep.name
        rep.party         = state_rep.party
        rep.role          = state_rep.office
        rep.photo         = state_rep.photo
        rep.url           = state_rep.url
        rep.office_locations << instantiate_office_locations(rep, state_rep)
      end
    end
  end

  def instantiate_office_locations(rep, state_rep)
    state_rep.office_locations.map do |state_rep_office|
      OfficeLocation.new do |office_location|
        office_location.rep         = rep
        office_location.address     = "#{state_rep_office.line_1} #{state_rep_office.line_2}".strip
        office_location.city        = state_rep_office.city
        office_location.state       = state_rep_office.state
        office_location.zip         = state_rep_office.zip
        office_location.phone       = state_rep_office.phone
        office_location.office_type = state_rep_office.type
        office_location.v_card      = office_location.make_vcard.to_s
      end
    end
  end
end
