# frozen_string_literal: true

class GeoRepRepresenter
  delegate(*Rep.columns.map(&:name),
           :state,
           :district,
           :sort_offices,
           :sorted_offices,
           to: :rep)

  attr_reader :rep, :coordinates

  def initialize(rep, coordinates)
    @rep = rep
    @coordinates = coordinates
  end

  def active_office_locations
    @office_locations ||= sort_offices(coordinates)
  end
end
