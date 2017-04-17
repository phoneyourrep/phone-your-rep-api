# frozen_string_literal: true

class OfficeLocationsController < ApplicationController
  before_action :set_office_location, only: [:show]

  def index
    address, lat, long, radius = geo_params

    if address || lat || long && radius
      geo = GeoLookup.new address: address, lat: lat, long: long, radius: radius
      @office_locations = geo.find_office_locations
    elsif params[:generate] == 'true'
      @office_locations = OfficeLocation.active.order(:office_id)
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
