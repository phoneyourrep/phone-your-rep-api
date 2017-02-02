# frozen_string_literal: true
class VCardsController < ApplicationController
  def index
    v_card   = params[:v_card]
    rep_name = params[:rep]
    send_data v_card, filename: "#{rep_name}.vcf" if v_card && rep_name
  end

  def show
    @office = OfficeLocation.find_with_rep(params.require(:id)).first
    @rep    = @office.rep

    send_data @office.v_card, filename: "#{@rep.official_full} #{@rep.state.abbr}.vcf"
    impressionist @office, '', unique: [:ip_address]
  end
end
