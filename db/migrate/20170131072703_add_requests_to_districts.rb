# frozen_string_literal: true
class AddRequestsToDistricts < ActiveRecord::Migration[5.0]
  def change
    add_column :districts, :requests, :integer, default: 0
  end
end
