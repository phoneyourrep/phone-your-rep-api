# frozen_string_literal: true

class ChangeColumnsInReps < ActiveRecord::Migration[5.0]
  def change
    add_column    :reps, :nickname, :string
    rename_column :reps, :name, :official_full
    rename_column :reps, :first_name, :first
    rename_column :reps, :middle_name, :middle
    rename_column :reps, :last_name, :last
    rename_column :reps, :website, :url
    rename_column :reps, :email, :contact_form
    change_column :reps, :contact_form, :string
  end
end
