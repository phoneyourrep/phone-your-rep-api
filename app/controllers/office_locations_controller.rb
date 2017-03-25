# frozen_string_literal: true
class OfficeLocationsController < ApplicationController
  before_action :set_office_location, only: [:show]

  def index
    @office_locations = OfficeLocation.all
    @self             = request.url
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
