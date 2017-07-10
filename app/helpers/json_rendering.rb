# frozen_string_literal: true

class JsonRendering
  include Rails.application.routes.url_helpers

  attr_reader :json, :route_prefix

  def initialize(json, options = {})
    options.symbolize_keys!
    @json = json
    @route_prefix = options[:route_prefix].to_s
    @route_prefix += '_' unless @route_prefix.end_with?('_') || @route_prefix.blank?
  end

  %i[rep_url state_url district_url office_location_url].each do |method_name|
    define_method(method_name) do |id|
      if route_prefix.blank?
        super(id)
      else
        send("#{route_prefix}#{method_name}", id)
      end
    end
  end

  def response(symbol, object)
    send(symbol, object)
  end

  def reps(reps)
    json.array! reps do |rep|
      self.rep rep
    end
  end

  def office_locations(office_locations)
    json.array! office_locations do |office_location|
      self.office_location office_location
    end
  end

  def rep(rep)
    return not_found if rep.blank?
    json.self rep_url(rep.official_id)
    state_and_district_for_rep(rep)
    _rep rep
    json.set! 'office_locations', rep.active_office_locations do |office_location|
      self.office_location office_location
    end
  end

  def state_and_district_for_rep(rep)
    json.state { state rep.state }
    json.district { district rep.district } if rep.district
  end

  def not_found
    json.error 'Record not found'
  end

  def state(state)
    json.self state_url(state.state_code)
    json.extract! state, :state_code, :name, :abbr
  end

  def district(district)
    json.self district_url(district.full_code)
    json.extract! district, :full_code, :code, :state_code, :level, :chamber, :name
  end

  def office_location(office_location)
    json.self office_location_url(office_location.office_id)
    json.rep rep_url(office_location.official_id)
    json.extract! office_location, :active, :official_id, :level, :office_id,
                  :bioguide_id, :state_leg_id, :office_type, :distance, :building,
                  :address, :suite, :city, :state, :zip, :phone, :fax, :hours,
                  :latitude, :longitude, :v_card_link, :downloads, :qr_code_link
  end

  def _rep(rep)
    json.extract! rep, :active, :official_id, :level, :bioguide_id, :state_leg_id,
                  :official_full, :chamber, :role, :party, :senate_class, :last,
                  :first, :middle, :nickname, :suffix, :contact_form, :url, :photo,
                  :twitter, :facebook, :youtube, :instagram, :googleplus, :twitter_id,
                  :facebook_id, :youtube_id, :instagram_id
  end
end
