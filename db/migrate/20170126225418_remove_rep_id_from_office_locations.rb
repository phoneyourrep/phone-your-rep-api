# frozen_string_literal: true

class RemoveRepIdFromOfficeLocations < ActiveRecord::Migration[5.0]
  def change
    remove_column :office_locations, :rep_id
  end
end
