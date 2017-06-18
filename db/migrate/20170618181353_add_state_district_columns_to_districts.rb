# frozen_string_literal: true

class AddStateDistrictColumnsToDistricts < ActiveRecord::Migration[5.0]
  def change
    add_column :districts, :name, :string
    add_column :districts, :chamber, :string
    add_column :districts, :type, :string
  end
end
