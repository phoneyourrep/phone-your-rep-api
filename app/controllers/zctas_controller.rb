# frozen_string_literal: true

class ZctasController < ApplicationController
  before_action :set_zcta, only: [:show]

  def index
    respond_to do |format|
      format.html { render file: 'lib/zctas.json', layout: false, content_type: 'application/json' }
      format.txt  { send_file 'lib/zctas.txt', filename: 'zctas.txt' }
      format.json { send_file 'lib/zctas.json', filename: 'zctas.json' }
      format.yaml { send_file 'lib/zctas.yaml', filename: 'zctas.yaml' }
    end
  end

  def show
    return if @zcta.blank?
    @districts = @zcta.districts
    return if params[:reps] != 'true'
    @reps = Rep.yours(state: @zcta.districts.first.state, district: @zcta.districts).
            active.
            distinct
  end

  private

  def zcta_params
    params.require(:zcta).permit(:id)
  end

  def set_zcta
    @zcta = Zcta.where(zcta: params[:id]).includes(districts: :state).take
  end
end
