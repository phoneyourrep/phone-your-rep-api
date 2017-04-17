# frozen_string_literal: true

class AddColumnsToZctaDistricts < ActiveRecord::Migration[5.0]
  def change
    add_column :zcta_districts, :zip_code, :string
    add_column :zcta_districts, :state, :string
    add_column :zcta_districts, :district_code, :string
  end
end
