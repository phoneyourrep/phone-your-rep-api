#frozen_string_literal: true
class RenameVCardOnOfficeLocation < ActiveRecord::Migration[5.0]
  def change
    change_table :office_locations do |t|
      t.rename :v_card, :v_card_simple
    end
  end
end
