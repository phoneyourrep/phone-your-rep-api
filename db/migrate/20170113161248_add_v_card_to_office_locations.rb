# frozen_string_literal: true

class AddVCardToOfficeLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :office_locations, :v_card, :string
  end
end
