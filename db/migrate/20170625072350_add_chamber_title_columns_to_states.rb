# frozen_string_literal: true

class AddChamberTitleColumnsToStates < ActiveRecord::Migration[5.0]
  def change
    add_column :states, :upper_chamber_title, :string
    add_column :states, :lower_chamber_title, :string
  end
end
