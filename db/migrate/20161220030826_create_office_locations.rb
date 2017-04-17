# frozen_string_literal: true

class CreateOfficeLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :office_locations do |t|
      t.belongs_to :rep, index: true
      t.string     :office_type
      t.string     :office_name
      t.text       :phones
      t.string     :line1
      t.string     :line2
      t.string     :line3
      t.string     :line4
      t.string     :line5
      t.float      :latitude
      t.float      :longitude
      t.st_point   :lonlat

      t.timestamps
    end
  end
end
