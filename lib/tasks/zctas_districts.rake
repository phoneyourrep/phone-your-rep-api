# frozen_string_literal: true
namespace :pyr do
  namespace :zcta_districts do
    desc 'Export ZCTA district relationships to CSV'
    task :export do
      Dir.chdir(Rails.root.join('lib')) do
        File.open('zctas.csv', 'w') do |file|
          file.write ZctaDistrict.order(:zip_code).to_csv
        end
      end
    end

    desc 'Update ZCTA district data'
    task :update do
      ZctaDistrict.all.each do |zd|
        zd.zip_code      = zd.zcta.zcta
        zd.state         = zd.district.state.abbr
        zd.district_code = zd.district.code
        zd.save
        puts "Updated #{zd.zip_code} - #{zd.district.full_code}"
      end
      Rake::Task['pyr:zcta_districts:export'].invoke
    end
  end
end
