# frozen_string_literal: true

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular 'zcta', 'zcta'
end

class CreateZctaDistricts < ActiveRecord::Migration[5.0]
  def change
    create_table :zcta_districts do |t|
      t.belongs_to :zcta, foreign_key: true
      t.belongs_to :district, foreign_key: true

      t.timestamps
    end
  end
end
