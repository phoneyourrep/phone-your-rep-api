# frozen_string_literal: true

namespace :db do
  namespace :pyr do
    desc 'Drop schema and tables, rebuild and seed the database'
    task :setup do
      if Rails.env.development?
        `rm db/schema.rb`
        sh 'bundle exec rake db:drop'
        sh 'bundle exec rake db:create'
      end
      sh 'bundle exec rake db:gis:setup'
      sh 'bundle exec rake db:migrate'
      sh 'bundle exec rubocop db --auto-correct'
    end

    desc 'Rebuild the database with an alert at completion for MacOS'
    task setup_and_seed: [:setup] do
      sh 'bundle exec rake db:seed'
      `say -v Fiona "Bring me a cold one, I'm exhausted"`
    end
  end
end
