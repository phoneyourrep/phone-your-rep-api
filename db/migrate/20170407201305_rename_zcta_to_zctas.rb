# frozen_string_literal: true
class RenameZctaToZctas < ActiveRecord::Migration[5.0]
  def up
    rename_table :zcta, :zctas
  end

  def down
    rename_table :zctas, :zcta
  end
end
