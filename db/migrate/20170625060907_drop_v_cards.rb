# frozen_string_literal: true

class DropVCards < ActiveRecord::Migration[5.0]
  def change
    drop_table :v_cards
  end
end
