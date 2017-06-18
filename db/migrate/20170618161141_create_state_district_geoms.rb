# frozen_string_literal: true

class CreateStateDistrictGeoms < ActiveRecord::Migration[5.0]
  def change
    create_table :state_district_geoms do |t|
      t.string :full_code
      t.string :chamber
      t.geometry :geom, srid: 3857

      t.timestamps
    end
  end
end
