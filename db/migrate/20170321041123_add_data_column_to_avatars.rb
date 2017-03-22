# frozen_string_literal: true
class AddDataColumnToAvatars < ActiveRecord::Migration[5.0]
  def change
    add_column :avatars, :data, :bytea
  end
end
