# frozen_string_literal: true

require 'db_pyr_update'
require 'import_zcta'
require 'shapefiles'
require 'state_district_importer'

namespace :db do
  namespace :pyr do
    desc 'Import shapefiles'
    task :shapefiles do
      StateGeom.destroy_all
      CongressionalDistrictGeom.destroy_all
      states = Shapefiles.new(
        'lib',
        'shapefiles',
        'us_states_122116',
        'cb_2015_us_state_500k.shp'
      )
      states.import(
        model:       StateGeom,
        model_attr:  :state_code,
        record_attr: 'STATEFP'
      )

      districts = Shapefiles.new(
        'lib',
        'shapefiles',
        'us_congress_districts_122116',
        'cb_2015_us_cd114_500k.shp'
      )
      districts.import(
        model:         CongressionalDistrictGeom,
        model_attr:    :full_code,
        record_attr:   'GEOID'
      )

      Rake::Task['pyr:state_districts:load_shapefiles'].invoke
    end

    desc 'Import ZCTAs'
    task :zctas do
      Zcta.destroy_all
      zcta = ImportZCTA.new(
        *Dir[Rails.root.join('lib', 'seeds', 'zcta_cd', '*')]
      )
      zcta.import
      puts "There are now #{Zcta.count} ZCTAs in the database."
      Rake::Task['pyr:zcta_districts:export'].invoke
    end

    desc 'Generate VCards'
    task :v_cards do
      OfficeLocation.all.each do |off|
        off.add_v_card
        puts "Added VCard for #{off.office_id}"
      end
    end

    desc 'Destroy all States and seed from scratch'
    task :seed_states do
      State.destroy_all
      csv_state_text = File.read(Rails.root.join('lib', 'seeds', 'states.csv'))
      csv_states = CSV.parse(csv_state_text, headers: true, encoding: 'ISO-8859-1')
      csv_states.each do |row|
        State.new do |s|
          s.state_code = row['state_code']
          s.name       = row['name']
          s.abbr       = row['abbr']
          s.save
          puts "#{s.name} saved in database."
        end
      end
      puts "There are now #{State.count} states in the database."
    end

    desc 'Destroy all Districts and seed from Scratch'
    task seed_districts: [:seed_state_districts] do
      CongressionalDistrict.destroy_all
      csv_district_text = File.read(Rails.root.join('lib', 'seeds', 'districts.csv'))
      csv_districts = CSV.parse(csv_district_text, headers: true, encoding: 'ISO-8859-1')
      csv_districts.each do |row|
        CongressionalDistrict.new do |d|
          d.code       = row['code']
          d.state_code = row['state_code']
          d.full_code  = row['full_code']
          d.save
          puts "District #{d.code} of #{d.state.name} saved in database."
        end
      end
      puts "There are now #{CongressionalDistrict.count} districts in the database."
    end

    desc 'Destroy all State Districts and seed from scratch'
    task :seed_state_districts do
      Rake::Task['pyr:state_districts:import'].invoke
    end

    desc 'Destroy all Reps and seed from Scratch'
    task :seed_reps do
      Rep.destroy_all
      Rake::Task['db:pyr:update:current_reps'].invoke
      puts "There are now #{Rep.count} reps and #{OfficeLocation.count} offices in the database."
      Rake::Task['db:pyr:update:socials'].invoke
      OfficeLocation.destroy_all(office_type: 'district')
      Rake::Task['db:pyr:update:office_locations'].invoke
      puts "There are now #{OfficeLocation.count} office locations in the database."
    end
  end
end
