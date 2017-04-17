# frozen_string_literal: true

class ChangeOfficeLocationsAddressLines < ActiveRecord::Migration[5.0]
  def change
    rename_column :office_locations, :line3, :city
    rename_column :office_locations, :line4, :state
    rename_column :office_locations, :line5, :zip
  end
end
