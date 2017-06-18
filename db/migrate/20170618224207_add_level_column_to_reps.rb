# frozen_string_literal: true

class AddLevelColumnToReps < ActiveRecord::Migration[5.0]
  def change
    add_column :reps, :level, :string
  end
end
