# frozen_string_literal: true

namespace :db do
  namespace :pyr do
    desc 'Drop schema and tables, rebuild and seed the database'
    task :setup do
      if Rails.env.development?
        sh 'bundle exec rake db:drop'
        sh 'bundle exec rake db:create'
      end

      if Rails.env.production? && ENV['FORCE'] != 'true'
        raise StandardError, 'This process will reset your database, and is not advised in '\
          'production. Run `rake db:pyr:setup[_and_seed] FORCE=true` to ignore this warning.'
      else
        sh 'bundle exec rake db:gis:setup'
        sh 'bundle exec rake db:schema:load'
        sh 'bundle exec rubocop db --auto-correct'
      end
    end

    desc 'Rebuild the database with an alert at completion for MacOS'
    task setup_and_seed: [:setup] do
      sh 'bundle exec rake db:seed'
      `say -v Fiona "Bring me a cold one, I'm exhausted"`
    end
  end
end
