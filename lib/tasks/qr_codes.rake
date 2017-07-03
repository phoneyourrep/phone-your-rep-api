# frozen_string_literal: true

namespace :pyr do
  namespace :qr_codes do
    # Set the "PYR_S3_BUCKET" environment variable on your machine or
    # at the command line (e.g. `rake some_task PYR_S3_BUCKET=your-own-bucket`)
    # if you wish to generate and upload your own images.
    S3_BUCKET = ENV['PYR_S3_BUCKET']

    desc 'Generate QR code images for all office locations'
    task :generate, [:rep_set] do |_t, args|
      args.with_defaults(rep_set: 'congress')
      offices = case args[:rep_set]
      when 'congress' then OfficeLocation.active.rep_type('CongressionalRep')
      when 'governors' then OfficeLocation.active.rep_type('Governor')
      else OfficeLocation.active.rep_type('StateRep').state(args[:rep_set])
      end
      offices_count = offices.count
      i = 1
      start = Time.now
      offices.each do |office|
        office.add_qr_code_img
        finish = Time.now
        remaining = offices_count - i
        time_remaining = (finish - start) / i * remaining
        print "\rcreated #{i} QR code(s), #{remaining} remaining, #{estimate_time(time_remaining)}"
        i += 1
      end
    end

    desc 'Remove the image meta files and make the filenames predictable'
    task :clean do
      dir = lookup_qr_code_dir
      Dir.chdir(dir) do
        sh 'rm *meta.yml'
        files = Dir.glob('*.png')
        files.each do |old_filename|
          new_filename = old_filename.sub(/[a-zA-Z\d]+_/, '')
          File.rename("#{dir}/#{old_filename}", "#{dir}/#{new_filename}")
        end
      end
    end

    desc 'Empty the S3 bucket'
    task :empty, [:rep_set] do |_t, args|
      args.with_defaults(rep_set: 'congress')
      dir = lookup_qr_code_dir
      Dir.chdir(dir) do
        files = Dir.glob('*.png').join(" --include ")
        puts "Emptying contents of the #{S3_BUCKET} S3 bucket"
        sh "aws s3 rm s3://#{S3_BUCKET}/#{args[:rep_set]} --recursive"
      end
    end

    desc 'Upload images to S3 bucket'
    task :upload, [:rep_set] do |_t, args|
      args.with_defaults(rep_set: 'congress')
      dir = lookup_qr_code_dir
      Dir.chdir(dir) do
        puts 'Uploading new images'
        sh "aws s3 cp . s3://#{S3_BUCKET}/#{args[:rep_set]} --recursive --grants"\
          ' read=uri=http://acs.amazonaws.com/groups/global/AllUsers'
      end
    end

    desc 'Push to github'
    task :push, [:rep_set] do |_t, args|
      args.with_defaults(rep_set: 'congress')
      dir = lookup_qr_code_dir
      Dir.chdir('../qr_codes') do
        sh 'git pull'
        Dir.mkdir(args[:rep_set]) unless Dir.exist?(args[:rep_set])
      end
      Dir.chdir(dir) do
        Dir.glob('*.png').each do |filename|
          FileUtils.mv(filename, "../../../../../../../../qr_codes/#{args[:rep_set]}/#{filename}")
        end
      end
      Dir.chdir('../qr_codes') do
        sh "git add #{args[:rep_set]}/*.png && git commit -m "\
          "'update QR codes #{Time.now}' && git push"
      end
    end

    desc 'Delete images source file'
    task :delete do
      dir = lookup_qr_code_dir
      sh "rm -rf #{dir}"
      puts 'Deleted local copies'
    end

    desc 'Generate QR codes, upload to S3 bucket, and delete locally for Congress by default'
    task :create, [:rep_set] => %i[generate clean empty upload push delete]

    desc 'Generate QR codes, upload to S3 bucket, and delete locally for all reps'
    task :create_all do
      args = State.all.pluck(:abbr)
      args += %w[congress governors]
      args.each do |arg|
        Rake::Task[:create].invoke(arg)
      end
    end

    def estimate_time(time)
      minutes = (time / 60).round
      if minutes > 1
        "approx. #{minutes} minutes   "
      elsif minutes < 1
        '< 1 minute                   '
      end
    end

    def lookup_qr_code_dir
      if ENV['dir']
        ENV['dir']
      else
        date  = DateTime.now
        year  = date.strftime('%Y')
        month = date.strftime('%m')
        day   = date.strftime('%d')
        Rails.root.join(
          'public/system/dragonfly/development', year, month, day
        )
      end
    end
  end
end
