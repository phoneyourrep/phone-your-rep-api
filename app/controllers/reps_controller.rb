# frozen_string_literal: true
class RepsController < ApplicationController
  acts_as_token_authentication_handler_for User, only: [:create, :update, :destroy]
  before_action :set_rep, only: [:show, :update, :destroy]
  after_action :make_impression, only: [:index]

  # GET /reps
  def index
    address = params[:address]
    lat     = params[:lat]
    long    = params[:long]
    # return the first result, or a random one
    if address || lat || long
      @reps = Rep.find_em address: address, lat: lat, long: long
      return if @reps.blank?
      house_rep = @reps.detect { |rep| !rep.district.blank? }
      @district = house_rep.district if house_rep
    elsif params[:generate] == 'true'
      @reps = Rep.where(active: true).includes(:office_locations, :district, :state)
    else
      respond_to do |format|
      format.html { render file: 'reps.json', layout: false, content_type: 'application/json' }
      format.json { send_file 'reps.json', filename: 'reps.json' }
      format.yaml { send_file 'reps.yaml', filename: 'reps.yaml' }
      end
    end
    @self = request.url
  end

  # GET /reps/1
  def show; end

  # POST /reps
  def create
    @rep = Rep.new(rep_params)

    if @rep.save
      render json: @rep, status: :created, location: @rep
    else
      render json: @rep.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reps/1
  def update
    if @rep.update(rep_params)
      render json: @rep
    else
      render json: @rep.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reps/1
  def destroy
    @rep.destroy
  end

  private

  def rep_params
    params.require(:rep).permit(:id, :bioguide_id)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_rep
    @rep = Rep.find_by(bioguide_id: params[:id])
    @pfx = request.protocol + request.host_with_port
  end

  def make_impression
    return if @district.blank?
    impressionist @district, '', unique: [:ip_address]
  end
end
