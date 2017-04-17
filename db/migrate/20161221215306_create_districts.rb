# frozen_string_literal: true

class CreateDistricts < ActiveRecord::Migration[5.0]
  def change
    create_table :districts do |t|
      t.belongs_to :state, index: true
      t.string     :code
      t.string     :state_code
      t.string     :full_code, unique: true
    end
  end
end
