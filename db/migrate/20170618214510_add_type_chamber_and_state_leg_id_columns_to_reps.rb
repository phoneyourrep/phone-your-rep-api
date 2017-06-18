# frozen_string_literal: true

class AddTypeChamberAndStateLegIdColumnsToReps < ActiveRecord::Migration[5.0]
  def change
    add_column :reps, :type, :string
    add_column :reps, :chamber, :string
    add_column :reps, :state_leg_id, :string
  end
end
