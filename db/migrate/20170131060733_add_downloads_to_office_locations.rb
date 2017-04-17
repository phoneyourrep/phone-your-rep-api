# frozen_string_literal: true

class AddDownloadsToOfficeLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :office_locations, :downloads, :integer, default: 0
  end
end
