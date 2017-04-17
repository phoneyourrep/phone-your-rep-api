# frozen_string_literal: true

class AddSocialsToReps < ActiveRecord::Migration[5.0]
  def change
    add_column :reps, :instagram, :string
    add_column :reps, :instagram_id, :integer
    add_column :reps, :facebook_id, :string
    add_column :reps, :youtube_id, :string
    add_column :reps, :twitter_id, :integer
  end
end
