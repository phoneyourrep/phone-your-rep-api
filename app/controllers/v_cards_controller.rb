# frozen_string_literal: true
class VCardsController < ApplicationController
  def show
    @office = OfficeLocation.with_v_card(params.require(:id)).first
    @rep    = @office.rep

    v_card = if @office.v_card.blank?
               @office.v_card_simple
             else
               @office.v_card.data
             end
    send_data v_card, filename: "#{@rep.official_full} #{@rep.state.abbr}.vcf"
    impressionist @office, '', unique: [:ip_address]
  end
end
