# frozen_string_literal: true
class OfficeLocationsController < ApplicationController
  before_action :set_office_location, only: [:show]

  def index
    if params[:generate] == 'true'
      @office_locations = OfficeLocation.active
      @self             = request.url
    else
      send_index_files
    end
  end

  def send_index_files
    respond_to do |format|
      format.html do
        render file: 'office_locations.json', layout: false, content_type: 'application/json'
      end
      format.json { send_file 'office_locations.json', filename: 'office_locations.json' }
      format.yaml { send_file 'office_locations.yaml', filename: 'office_locations.yaml' }
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
