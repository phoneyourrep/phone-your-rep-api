# frozen_string_literal: true
require 'db_pyr_update'

namespace :db do
  namespace :pyr do
    namespace :update do
      desc 'Retire historical reps'
      task :retired_reps do
        if ENV['file']
          file = ENV['file']
        else
          file = Dir.glob(
            Rails.root.join('lib', 'seeds', '*legislators-historical*.y*l')
          ).last
        end
        update = DbPyrUpdate::HistoricalReps.new(file)
        update.call
      end

      desc 'Update current reps in database from yaml data file'
      task :current_reps do
        if ENV['file']
          file = ENV['file']
        else
          file = Dir.glob(
            Rails.root.join('lib', 'seeds', '*legislators-current*.y*l')
          ).last
        end
        update = DbPyrUpdate::Reps.new(file)
        update.call
      end

      desc 'Update rep social media accounts from yaml data file'
      task :socials do
        if ENV['file']
          file = ENV['file']
        else
          file = Dir.glob(
            Rails.root.join('lib', 'seeds', '*legislators-social-media*.y*l')
          ).last
        end
        update = DbPyrUpdate::Socials.new(file)
        update.call
      end

      desc 'Update office locations in database from yaml data file'
      task :office_locations do
        if ENV['file']
          file = ENV['file']
        else
          file = Dir.glob(
            Rails.root.join('lib', 'seeds', '*legislators-district-offices*.y*l')
          ).last
        end
        update = DbPyrUpdate::OfficeLocations.new(file)
        update.call
      end

      desc 'Update all rep and office_location data from default yaml files'
      task all: [:retired_reps, :current_reps, :socials, :office_locations]
    end
  end
end
