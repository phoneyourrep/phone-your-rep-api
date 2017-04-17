# frozen_string_literal: true

class CreateReps < ActiveRecord::Migration[5.0]
  def change
    create_table :reps do |t|
      t.belongs_to :district, index: true
      t.belongs_to :state, index: true
      t.string     :office
      t.string     :name
      t.string     :last_name
      t.string     :first_name
      t.string     :middle_name
      t.string     :suffix
      t.string     :party
      t.text       :email
      t.string     :website
      t.string     :twitter
      t.string     :facebook
      t.string     :youtube
      t.string     :googleplus
      t.text       :committees
      t.string     :senate_class
      t.string     :bioguide_id
      t.string     :photo

      t.timestamps
    end
  end
end
