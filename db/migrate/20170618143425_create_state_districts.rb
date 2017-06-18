# frozen_string_literal: true

class CreateStateDistricts < ActiveRecord::Migration[5.0]
  def change
    create_table :state_districts do |t|
      t.string :state_code
      t.string :code
      t.string :full_code, unique: true
      t.string :name
      t.string :chamber
      t.integer :requests, default: 0

      t.timestamps
    end
  end
end
