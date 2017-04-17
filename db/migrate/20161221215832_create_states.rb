# frozen_string_literal: true

class CreateStates < ActiveRecord::Migration[5.0]
  def change
    create_table :states do |t|
      t.string   :state_code, unique: true
      t.string   :name, unique: true
      t.string   :abbr, unique: true
    end
  end
end
