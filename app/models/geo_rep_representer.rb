class GeoRepRepresenter
  delegate *Rep.columns.map(&:name),
           :state,
           :district,
           :sort_offices,
           :sorted_offices_array,
           to: :rep

  attr_reader :rep, :coordinates

  def initialize(rep, coordinates)
    @rep = rep
    @coordinates = coordinates
  end

  def office_locations
    @office_locations ||= sort_offices(coordinates) && sorted_offices_array
  end
end