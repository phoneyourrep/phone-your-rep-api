# frozen_string_literal: true
namespace :pyr do
  namespace :zcta_districts do
    desc 'Update ZCTA district data'
    task :update do
      ZctaDistrict.all.each do |zd|
        zd.zip_code      = zd.zcta.zcta
        zd.state         = zd.district.state.abbr
        zd.district_code = zd.district.code
        zd.save
        puts "Updated #{zd.zip_code} - #{zd.district.full_code}"
      end
    end
  end
end
