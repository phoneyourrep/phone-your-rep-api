# frozen_string_literal: true

class RepsController < ApplicationController
  before_action :set_rep, only: :show
  after_action :make_impression, only: :index
  has_scope :state,
            :party,
            :chamber,
            :district,
            :level,
            :last_name,
            :official_ids,
            only: %i[index official_ids]
  has_scope :independent,
            :republican,
            :democrat,
            :lower,
            :upper,
            :legislators,
            :governors,
            type: :boolean,
            only: %i[index official_ids]

  # GET /reps
  def index
    execute_index_with_geo_method :find_national_legislators_only
  end

  def execute_index_with_geo_method(method)
    if geo_params.keys.any?
      geo = GeoLookup.new(geo_params.to_h.symbolize_keys)
      @district = geo.congressional_district
      @reps     = apply_scopes(geo.send(method)).map do |rep|
        GeoRepRepresenter.new(rep, geo.latlon)
      end
    elsif scopes_present?
      @reps = apply_scopes(Rep).active.order(:bioguide_id)
    else
      send_index_files :reps
    end
  end

  # GET /reps/1
  def show; end

  def official_ids
    @reps = apply_scopes(Rep).official_ids_and_names
    render json: @reps
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rep
    @rep = Rep.find_by(official_id: params[:id])
  end

  def make_impression
    return if @district.blank?
    impressionist @district, '', unique: [:ip_address]
  end
end
