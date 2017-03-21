# frozen_string_literal: true

namespace :pyr do
  namespace :qr_codes do

    # Set the "PYR_S3_BUCKET" environment variable on your machine or
    # at the command line (e.g. `rake some_task PYR_S3_BUCKET=your-own-bucket`)
    # if you wish to generate and upload your own images.
    S3_BUCKET = ENV['PYR_S3_BUCKET']

    desc 'Generate QR code images for all office locations'
    task :generate do
      active_offices = OfficeLocation.where(active: true)
      active_offices_count = active_offices.count
      i = 1
      start = Time.now
      active_offices.each do |office|
        office.add_qr_code_img
        finish = Time.now
        remaining = active_offices_count - i
        time_remaining = (finish - start)/i * remaining
        print "\rgenerated #{i} QR codes, #{remaining} remaining, #{estimate_time(time_remaining)}"
        i += 1
      end
    end

    def estimate_time(time)
      minutes = (time/60).round
      if minutes > 1
        "approx. #{minutes} minutes"
      elsif minutes < 1
        '< 1 minute'
      end
    end

    desc 'Remove the image meta files and make the filenames predictable'
    task :clean do
      dir = get_dir
      Dir.chdir(dir.to_s) do
        sh 'rm *meta.yml'
        files = Dir.glob('*.png')
        files.each do |old_filename|
          new_filename = old_filename.sub(/[a-zA-Z\d]+_/, '')
          File.rename("#{dir}/#{old_filename}", "#{dir}/#{new_filename}")
        end
      end
    end

    desc 'Empty the S3 bucket'
    task :empty do
      puts "Emptying contents of the #{S3_BUCKET} S3 bucket"
      sh "aws s3 rm s3://#{S3_BUCKET} --recursive"
    end

    desc 'Upload images to S3 bucket'
    task :upload do
      dir = get_dir
      Dir.chdir(dir.to_s) do
        puts 'Uploading new images'
        sh "aws s3 cp . s3://#{S3_BUCKET}/ --recursive --grants"\
          ' read=uri=http://acs.amazonaws.com/groups/global/AllUsers'
      end
    end

    desc 'Delete images source file'
    task :delete do
      dir = get_dir
      sh "rm -rf #{dir.to_s}"
      puts 'Deleted local copies'
    end

    desc 'Generate QR codes, upload to S3 bucket, and delete locally'
    task create: [:generate, :clean, :empty, :upload, :delete]

    def get_dir
      if ENV['dir']
        ENV['dir']
      else
        month = Date.today.month.to_s
        day = Date.today.day.to_s
        m = month.length == 1 ? "0#{month}" : month
        d = day.length == 1 ? "0#{day}" : day
        y = Date.today.year.to_s
        Rails.root.join(
          'public/system/dragonfly/development', y, m, d
        )
      end
    end
  end
end
