# frozen_string_literal: true

class AddOpenStatesNameToDistricts < ActiveRecord::Migration[5.0]
  def change
    add_column :districts, :open_states_name, :string
  end
end
