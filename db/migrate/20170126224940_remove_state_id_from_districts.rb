# frozen_string_literal: true

class RemoveStateIdFromDistricts < ActiveRecord::Migration[5.0]
  def change
    remove_column :districts, :state_id
  end
end
