# frozen_string_literal: true

class StatesController < ApplicationController
  before_action :set_state, only: [:show]

  def index
    @states = State.all
    @self   = request.url
  end

  def show; end

  private

  def state_params
    params.require(:state).permit(:id)
  end

  def set_state
    @state = State.find_by(state_code: params[:id])
  end
end
