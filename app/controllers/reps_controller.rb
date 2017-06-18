# frozen_string_literal: true

class RepsController < ApplicationController
  before_action :set_rep, only: :show
  after_action :make_impression, only: :index
  has_scope :state, :party, :chamber, :district, only: :index
  has_scope :independent,
            :republican,
            :democrat,
            type: :boolean,
            only: :index

  # GET /reps
  def index
    if geo_params.keys.any?
      geo = GeoLookup.new(geo_params.to_h.symbolize_keys)
      @district = geo.congressional_district
      @reps     = apply_scopes(geo.find_reps).each do |rep|
        rep.sort_offices(geo.coordinates.latlon)
      end
    elsif scopes_present?
      @reps = apply_scopes(Rep).active.order(:bioguide_id)
    else
      send_index_files :reps
    end
  end

  # GET /reps/1
  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rep
    @rep = Rep.find_by(bioguide_id: params[:id])
  end

  def make_impression
    return if @district.blank?
    impressionist @district, '', unique: [:ip_address]
  end
end
