# frozen_string_literal: true

class ChangeRepSocialDataTypes < ActiveRecord::Migration[5.0]
  def change
    change_column :reps, :twitter_id, :string
    change_column :reps, :instagram_id, :string
  end
end
