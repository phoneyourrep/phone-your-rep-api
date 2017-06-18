# frozen_string_literal: true

class CreateStateDistricts < ActiveRecord::Migration[5.0]
  def change
    create_table :state_districts do |t|
      t.belongs_to :state, index: true
      t.string :state_code
      t.string :code
      t.string :full_code, unique: true
      t.string :name

      t.timestamps
    end
  end
end
