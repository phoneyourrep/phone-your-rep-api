# frozen_string_literal: true
class CreateVCards < ActiveRecord::Migration[5.0]
  def change
    create_table :v_cards do |t|
      t.text :data
      t.belongs_to :office_location, foreign_key: true

      t.timestamps
    end
  end
end
