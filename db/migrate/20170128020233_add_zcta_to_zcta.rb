# frozen_string_literal: true

class AddZctaToZcta < ActiveRecord::Migration[5.0]
  def change
    add_column :zcta, :zcta, :string
  end
end
