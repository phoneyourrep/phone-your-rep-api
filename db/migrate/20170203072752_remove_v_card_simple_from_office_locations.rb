# frozen_string_literal: true

class RemoveVCardSimpleFromOfficeLocations < ActiveRecord::Migration[5.0]
  def change
    remove_column :office_locations, :v_card_simple, :string
  end
end
