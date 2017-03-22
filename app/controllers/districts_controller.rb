# frozen_string_literal: true
class DistrictsController < ApplicationController
  before_action :set_district, only: [:show]

  def index
    @districts = District.all
    @self      = request.url
  end

  def show; end

  private

  def district_params
    params.require(:district).permit(:id)
  end

  def set_district
    @district = District.find_by(full_code: params[:id])
  end
end
