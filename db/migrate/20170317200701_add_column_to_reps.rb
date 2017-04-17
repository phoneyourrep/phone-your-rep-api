# frozen_string_literal: true

class AddColumnToReps < ActiveRecord::Migration[5.0]
  def change
    add_column :reps, :active, :boolean, default: true
  end
end
