#frozen_string_literal: true
class RemoveVCardFromOfficeLocation < ActiveRecord::Migration[5.0]
  def change
    remove_column :office_locations, :v_card
  end
end
