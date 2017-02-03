# frozen_string_literal: true
class VCardsController < ApplicationController
  def show
    @office = OfficeLocation.with_v_card(params.require(:id)).first
    @rep    = @office.rep

    send_data @office.v_card.data, filename: "#{@rep.official_full} #{@rep.state.abbr}.vcf"
    impressionist @office, '', unique: [:ip_address]
  end
end
