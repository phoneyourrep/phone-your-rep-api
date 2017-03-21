# frozen_string_literal: true
require_relative '../config/environment.rb'

class Shapefiles
  attr_reader :file

  def initialize(*args)
    @file = Rails.root.join(*args).to_s
  end

  def import(model:, model_attr:, record_attr:)
    RGeo::Shapefile::Reader.open(file, factory: Geographic::FACTORY) do |file|
      puts "File contains #{file.num_records} records."
      file.each do |record|
        add_record(model, model_attr, record, record_attr)
      end
    end
  end

  private

  def add_record(model, model_attr, record, record_attr)
    puts "Record number #{record.index}:"
    record.geometry.projection.each do |poly|
      model.create(model_attr => record.attributes[record_attr],
                   :geom      => poly)
    end
    puts record.attributes
  end
end
