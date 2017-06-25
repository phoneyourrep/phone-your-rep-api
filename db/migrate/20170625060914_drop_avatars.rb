# frozen_string_literal: true

class DropAvatars < ActiveRecord::Migration[5.0]
  def change
    drop_table :avatars
  end
end
