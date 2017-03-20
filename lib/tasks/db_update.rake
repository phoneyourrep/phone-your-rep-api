# frozen_string_literal: true
require 'db_pyr_update'

namespace :db do
  namespace :pyr do
    namespace :update do
      def get_file(*default)
        if ENV['file']
          ENV['file']
        else
          Dir.glob(
            Rails.root.join(*default)
          ).last
        end
      end

      desc 'Retire historical reps'
      task :retired_reps do
        file = get_file('lib', 'seeds', '*legislators-historical*.y*l')
        update = DbPyrUpdate::HistoricalReps.new(file)
        update.call
      end

      desc 'Update current reps in database from yaml data file'
      task :current_reps do
        file = get_file('lib', 'seeds', '*legislators-current*.y*l')
        update = DbPyrUpdate::Reps.new(file)
        update.call
      end

      desc 'Update rep social media accounts from yaml data file'
      task :socials do
        file = get_file('lib', 'seeds', '*legislators-social-media*.y*l')
        update = DbPyrUpdate::Socials.new(file)
        update.call
      end

      desc 'Update office locations in database from yaml data file'
      task :office_locations do
        file = get_file('lib', 'seeds', '*legislators-district-offices*.y*l')
        update = DbPyrUpdate::OfficeLocations.new(file)
        update.call
      end

      desc 'Update all rep and office_location data from default yaml files'
      task all: [:retired_reps, :current_reps, :socials, :office_locations]
    end
  end
end
