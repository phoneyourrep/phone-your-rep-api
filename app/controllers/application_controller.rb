# frozen_string_literal: true

require 'application_responder'

class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  self.responder = ApplicationResponder
  respond_to :json

  before_action :set_prefix, :set_self

  private

  def scopes_present?
    params[:generate] == 'true' || scopes_configuration.any? { |scope, _options| params.key? scope }
  end

  def geo_params
    params.permit(:address, :lat, :long, :radius)
  end

  def set_prefix
    @pfx = request.protocol + request.host_with_port
  end

  def set_self
    @self = request.url
  end

  def send_index_files(table_name, source: nil)
    source = table_name unless source
    respond_to do |format|
      format.html do
        render file: "index_files/#{source}.json", layout: false, content_type: 'application/json'
      end

      format.json { send_file "index_files/#{source}.json", filename: "#{table_name}.json" }
      format.yaml { send_file "index_files/#{source}.yaml", filename: "#{table_name}.yaml" }
    end
  end
end
