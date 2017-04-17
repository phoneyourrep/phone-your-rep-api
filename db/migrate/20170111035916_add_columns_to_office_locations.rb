# frozen_string_literal: true

class AddColumnsToOfficeLocations < ActiveRecord::Migration[5.0]
  def change
    add_column    :office_locations, :bioguide_id, :string
    rename_column :office_locations, :line1, :address
    rename_column :office_locations, :line2, :building
    rename_column :office_locations, :office_name, :suite
    rename_column :office_locations, :phones, :phone
    change_column :office_locations, :phone, :string
    add_column    :office_locations, :fax, :string
    add_column    :office_locations, :hours, :string
  end
end
