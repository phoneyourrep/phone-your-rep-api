# frozen_string_literal: true

class AddLevelColumnToDistrictGeoms < ActiveRecord::Migration[5.0]
  def change
    add_column :district_geoms, :level, :string
  end
end
