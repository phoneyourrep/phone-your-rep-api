# frozen_string_literal: true

class AddOfficialIdColumnToReps < ActiveRecord::Migration[5.0]
  def change
    add_column :reps, :official_id, :string
  end
end
