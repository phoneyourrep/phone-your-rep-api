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

      desc 'Export reps index to JSON and YAML files'
      task :export_reps do
        if Rails.env.development?
          sh "curl 'https://phone-your-rep.herokuapp.com/api/"\
            "beta/reps?generate=true' -o 'api_beta_reps.json'"
          data = JSON.parse File.read('api_beta_reps.json')
          data['_links']['self']['href'].sub!('?generate=true', '')
          File.open('api_beta_reps.json', 'w') { |json| json.write JSON.pretty_generate(data) }
          File.open('api_beta_reps.yaml', 'w') do |yaml|
            yaml.write JSON.parse(
              File.read('api_beta_reps.json')
            ).to_yaml
          end

          reps = data['reps']
          reps.each do |rep|
            rep['self'].sub!('api/beta/', '')
            rep['office_locations'].each do |office|
              office['self'].sub!('api/beta/', '')
              office['rep'].sub!('api/beta/', '')
            end
          end

          File.open('reps.json', 'w') { |json| json.write JSON.pretty_generate(reps) }
          File.open('reps.yaml', 'w') do |yaml|
            yaml.write JSON.parse(
              File.read('reps.json')
            ).to_yaml
          end
          puts `git add *reps.*; git commit -m 'update reps index files'`
          puts `git push heroku master` if ENV['deploy'] == 'true'
        end
      end

      desc 'Export office_locations index to JSON and YAML files'
      task :export_office_locations do
        if Rails.env.development?
          sh "curl 'https://phone-your-rep.herokuapp.com/api/"\
            "beta/office_locations?generate=true' -o 'api_beta_office_locations.json'"
          data = JSON.parse File.read('api_beta_office_locations.json')
          data['_links']['self']['href'].sub!('?generate=true', '')
          File.open('api_beta_office_locations.json', 'w') do |json|
            json.write JSON.pretty_generate(data)
          end

          File.open('api_beta_office_locations.yaml', 'w') do |file|
            file.write JSON.parse(
              File.read('api_beta_office_locations.json')
            ).to_yaml
          end

          offices = data['office_locations']
          offices.each do |office|
            office['self'].sub!('api/beta/', '')
            office['rep'].sub!('api/beta/', '')
          end

          File.open('office_locations.json', 'w') do |json|
            json.write JSON.pretty_generate(offices)
          end

          File.open('office_locations.yaml', 'w') do |yaml|
            yaml.write JSON.parse(
              File.read('office_locations.json')
            ).to_yaml
          end
          puts `git add *office_locations.*; git commit -m 'update office_locations index files'`
          puts `git push heroku master` if ENV['deploy'] == 'true'
        end
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
