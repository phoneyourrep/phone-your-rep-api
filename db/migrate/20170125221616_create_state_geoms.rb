# frozen_string_literal: true

class CreateStateGeoms < ActiveRecord::Migration[5.0]
  def change
    create_table :state_geoms do |t|
      t.belongs_to :state, index: true, foreign_key: true
      t.string     :state_code
      t.geometry   :geom, srid: 3857
    end
  end
end
