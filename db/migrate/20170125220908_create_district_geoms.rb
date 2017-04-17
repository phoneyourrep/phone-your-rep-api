# frozen_string_literal: true

class CreateDistrictGeoms < ActiveRecord::Migration[5.0]
  def change
    create_table :district_geoms do |t|
      t.belongs_to :district, index: true, foreign_key: true
      t.string     :full_code
      t.geometry   :geom, srid: 3857
    end
  end
end
