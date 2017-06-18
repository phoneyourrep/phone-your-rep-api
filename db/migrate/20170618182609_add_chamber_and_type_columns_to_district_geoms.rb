# frozen_string_literal: true

class AddChamberAndTypeColumnsToDistrictGeoms < ActiveRecord::Migration[5.0]
  def change
    add_column :district_geoms, :chamber, :string
    add_column :district_geoms, :type, :string
  end
end
