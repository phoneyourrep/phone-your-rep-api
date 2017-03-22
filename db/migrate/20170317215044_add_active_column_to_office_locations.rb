# frozen_string_literal: true
class AddActiveColumnToOfficeLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :office_locations, :active, :boolean, default: true
  end
end
