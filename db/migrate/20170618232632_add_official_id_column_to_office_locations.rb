# frozen_string_literal: true

class AddOfficialIdColumnToOfficeLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :office_locations, :official_id, :string
  end
end
