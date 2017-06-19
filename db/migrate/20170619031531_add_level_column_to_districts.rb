# frozen_string_literal: true

class AddLevelColumnToDistricts < ActiveRecord::Migration[5.0]
  def change
    add_column :districts, :level, :string
  end
end
