# frozen_string_literal: true

class CreateZcta < ActiveRecord::Migration[5.0]
  def change
    create_table :zcta do |t|
      t.string :district_code

      t.timestamps
    end
  end
end
