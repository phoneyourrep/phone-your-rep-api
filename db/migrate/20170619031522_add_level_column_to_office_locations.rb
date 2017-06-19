# frozen_string_literal: true

class AddLevelColumnToOfficeLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :office_locations, :level, :string
  end
end
