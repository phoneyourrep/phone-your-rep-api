# frozen_string_literal: true

class VCardsController < ApplicationController
  def show
    @office   = OfficeLocation.with_v_card(params.require(:id)).first
    @office ||= OfficeLocation.find(params.require(:id))
    @rep      = @office.rep

    send_data @office.v_card.data, filename: "#{@rep.official_full} #{@office.city}.vcf"
    impressionist @office, '', unique: [:ip_address]
  rescue ActiveRecord::RecordNotFound => e
    logger.error e
    render plain: '404 VCard not found', status: 404
  end
end
