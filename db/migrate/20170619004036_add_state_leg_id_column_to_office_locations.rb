# frozen_string_literal: true

class AddStateLegIdColumnToOfficeLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :office_locations, :state_leg_id, :string
  end
end
