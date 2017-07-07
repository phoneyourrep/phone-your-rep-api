# frozen_string_literal: true

class AddQrCodeLinkColumnToOfficeLocations < ActiveRecord::Migration[5.1]
  def change
    add_column :office_locations, :qr_code_link, :string
  end
end
