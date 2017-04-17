# frozen_string_literal: true

class RemoveDistrictCodeFromZctas < ActiveRecord::Migration[5.0]
  def change
    remove_column :zcta, :district_code
  end
end
