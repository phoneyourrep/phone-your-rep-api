# frozen_string_literal: true

# Import state district data from CSV files to database
class StateDistrictImporter
  attr_accessor :filename

  def self.state_district_csv_files
    Dir.glob(Rails.root.join('lib/seeds/state_leg_districts/*/*.csv'))
  end

  def self.call
    StateDistrict.destroy_all
    state_district_csv_files.each do |filename|
      importer = new(filename)
      importer.import
    end
  end

  def initialize(filename)
    self.filename = filename
  end

  def import
    csv_state_districts = CSV.open(filename, headers: true, encoding: 'ISO-8859-1')
    csv_state_districts.each do |row|
      StateDistrict.find_or_create_by(full_code: row['full_code']) do |d|
        %w[code state_code name chamber type level open_states_name].each do |attribute|
          d.send("#{attribute}=", row[attribute])
        end
        puts "State #{d.chamber.capitalize} Legislative District #{d.code} of #{d.state.name} "\
          'saved in database.'
      end
    end
    puts "There are now #{StateDistrict.count} state districts in the database."
  end
end
