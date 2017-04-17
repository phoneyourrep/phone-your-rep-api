# frozen_string_literal: true

class RemoveMemberFullFromReps < ActiveRecord::Migration[5.0]
  def change
    remove_column :reps, :member_full
  end
end
