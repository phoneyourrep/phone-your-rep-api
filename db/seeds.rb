# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Rake::Task['db:pyr:seed_states'].invoke
Rake::Task['db:pyr:seed_districts'].invoke
Rake::Task['db:pyr:shapefiles'].invoke
Rake::Task['db:pyr:seed_reps'].invoke
Rake::Task['db:pyr:zctas'].invoke if ENV['zctas'] == 'true'
