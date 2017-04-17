# frozen_string_literal: true

class AddQrCodeToOfficeLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :office_locations, :qr_code_uid,  :string
    add_column :office_locations, :qr_code_name, :string
  end
end
