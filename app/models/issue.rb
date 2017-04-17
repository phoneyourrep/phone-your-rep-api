# frozen_string_literal: true

class Issue < ApplicationRecord
  belongs_to :office_location

  validates :issue_type, :office_location_id, presence: true

  # Tally of issues by category
  def self.aggregate_issues
    Issue.group(:issue_type).count
  end

  # Array of unresolved issues reported by constituents
  def self.unresolved
    Issue.where(resolved: false)
  end
end
