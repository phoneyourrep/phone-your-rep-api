# frozen_string_literal: true

class OfficeLocationsController < ApplicationController
  before_action :set_office_location, only: [:show]
  has_scope :district, :capitol, type: :boolean, only: :index

  def index
    if geo_params.keys.any?
      geo = GeoLookup.new geo_params
      @office_locations = apply_scopes(geo.find_office_locations).each do |off|
        off.calculate_distance(geo.coordinates.latlon)
      end
    elsif scopes_present?
      @office_locations = apply_scopes(OfficeLocation).active.order(:office_id)
    else
      send_index_files :office_locations
    end
  end

  def show; end

  private

  def office_location_params
    params.require(:office_location).permit(:id, :bioguide_id)
  end

  def set_office_location
    @office_location = OfficeLocation.find_by(office_id: params[:id])
  end
end
