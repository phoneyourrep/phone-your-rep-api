# frozen_string_literal: true

class StateGeom < ApplicationRecord
  include Geographic
  belongs_to :state, foreign_key: :state_code, primary_key: :state_code
end
