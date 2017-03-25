# frozen_string_literal: true
require 'db_pyr_update'
# require 'config/application'

namespace :db do
  namespace :pyr do
    namespace :update do
      desc 'Download updated legislators-historical.yaml'
      task :fetch_retired_reps do
        source = get_source(
          'https://raw.githubusercontent.com/unitedstates/congress-legislators/'\
            'master/legislators-historical.yaml'
        )
        file = get_file('lib', 'seeds', 'legislators-historical.yaml')
        update_yaml_file(file, source)
      end

      desc 'Retire historical reps'
      task retired_reps: [:fetch_retired_reps] do
        file = get_file('lib', 'seeds', 'legislators-historical.yaml')
        update = DbPyrUpdate::HistoricalReps.new(file)
        update.call
      end

      desc 'Download updated legislators-current.yaml'
      task :fetch_current_reps do
        source = get_source(
          'https://raw.githubusercontent.com/unitedstates/congress-legislators/'\
            'master/legislators-current.yaml'
        )
        file = get_file('lib', 'seeds', 'legislators-current.yaml')
        update_yaml_file(file, source)
      end

      desc 'Update current reps in database from yaml data file'
      task current_reps: [:fetch_current_reps] do
        file = get_file('lib', 'seeds', 'legislators-current.yaml')
        update = DbPyrUpdate::Reps.new(file)
        update.call
      end

      desc 'Download updated legislators-social-media.yaml'
      task :fetch_socials do
        source = get_source(
          'https://raw.githubusercontent.com/unitedstates/congress-legislators/'\
            'master/legislators-social-media.yaml'
        )
        file = get_file('lib', 'seeds', 'legislators-social-media.yaml')
        update_yaml_file(file, source)
      end

      desc 'Update rep social media accounts from yaml data file'
      task socials: [:fetch_socials] do
        file = get_file('lib', 'seeds', 'legislators-social-media.yaml')
        update = DbPyrUpdate::Socials.new(file)
        update.call
      end

      desc 'Download updated legislators-district-offices.yaml'
      task :fetch_office_locations do
        source = get_source(
          'https://raw.githubusercontent.com/thewalkers/congress-legislators/'\
            'master/legislators-district-offices.yaml'
        )
        file = get_file('lib', 'seeds', 'legislators-district-offices.yaml')
        update_yaml_file(file, source)
      end

      desc 'Update office locations in database from yaml data file'
      task office_locations: [:fetch_office_locations] do
        file = get_file('lib', 'seeds', 'legislators-district-offices.yaml')
        update = DbPyrUpdate::OfficeLocations.new(file)
        update.call
      end

      desc 'Update the raw YAML files only, without touching the database'
      task raw_data: [
        :fetch_retired_reps,
        :fetch_current_reps,
        :fetch_socials,
        :fetch_office_locations
      ]

      desc 'Export reps index to JSON file'
      task :export_reps do
        return if Rails.env.production?
        sh "curl 'localhost:3000/reps?generate=true' -o 'reps.json'"
        File.open('reps.yaml', 'w') do |file|
          file.write JSON.parse(
            File.open('reps.json', 'r', &:read)
          ).to_yaml
        end
        puts `git add reps.yaml reps.json; git commit -m 'update reps index files'`
        puts `git push heroku master` if ENV['deploy'] == 'true'
      end

      desc 'Update all reps and office_locations in database from default yaml files'
      task all: [:retired_reps, :current_reps, :socials, :office_locations] do
        if ENV['qr_codes'] == 'true' && Rails.env.development?
          Rake::Task['pyr:qr_codes:create'].invoke
        end
      end

      def get_source(default)
        if ENV['source']
          ENV['source']
        else
          default
        end
      end

      def get_file(*default)
        if ENV['file']
          Rails.root.join(ENV['file'])
        else
          Dir.glob(
            Rails.root.join(*default)
          ).last
        end
      end

      def update_yaml_file(file, source)
        sh "curl #{source} -o #{file}"
        return if Rails.env.production?
        puts `git add #{file}; git commit -m 'update #{file.to_s.split('/').last}'`
      end
    end
  end
end
