# frozen_string_literal: true

namespace :db do
  namespace :pyr do
    desc 'Drop schema and tables, rebuild and seed the database'
    task :setup do
      if Rails.env.development?
        `rm db/schema.rb`
        sh 'rake db:drop'
        sh 'rake db:create'
      end
      sh 'rake db:gis:setup'
      sh 'rake db:migrate'
      sh 'rake db:seed'
    end

    desc 'Rebuild the database with an alert at completion for MacOS'
    task setup_alert: [:setup] do
      `say -v Fiona "Bring me a cold one, I'm exhausted"`
    end
  end
end
