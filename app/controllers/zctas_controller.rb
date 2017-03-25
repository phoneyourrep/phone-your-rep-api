# frozen_string_literal: true
class ZctasController < ApplicationController
  before_action :set_zcta, only: [:show]

  def index
    respond_to do |format|
      format.csv { send_file 'lib/zctas.csv', filename: 'zctas.csv' }
    end
  end

  def show
    return if @zcta.blank?
    if params[:reps] == 'true'
      @reps = Rep.yours(state: @zcta.districts.first.state, district: @zcta.districts).distinct
    else
      @districts = @zcta.districts
    end
  end

  private

  def zcta_params
    params.require(:zcta).permit(:id)
  end

  def set_zcta
    @zcta = Zcta.where(zcta: params[:id]).includes(districts: :state).take
  end
end
