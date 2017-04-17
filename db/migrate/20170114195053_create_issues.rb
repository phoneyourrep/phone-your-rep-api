# frozen_string_literal: true

class CreateIssues < ActiveRecord::Migration[5.0]
  def change
    create_table :issues do |t|
      t.string  :issue_type, null: false
      t.boolean :resolved, default: false
      t.references :office_location
      t.timestamps
    end
  end
end
