# frozen_string_literal: true

class AddPhotoUrlColumnToReps < ActiveRecord::Migration[5.0]
  def change
    add_column :reps, :photo_url, :string
  end
end
