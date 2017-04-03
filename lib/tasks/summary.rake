# frozen_string_literal: true

namespace :pyr do
  desc 'Summarize the day\'s activity'
  task :summary do
    downloads = Impression.where impressionable_type: 'OfficeLocation',
                                 created_at: (Time.now - 24.hours)..Time.now
    download_count = downloads.count
    requests = Impression.where impressionable_type: 'District',
                                created_at: (Time.now - 24.hours)..Time.now
    request_count = requests.count

    most_downloaded_id = impression_sorter(downloads)
    most_downloads = OfficeLocation.find_by id: most_downloaded_id.call
    most_requested_id = impression_sorter(requests)
    most_requests = District.find_by id: most_requested_id.call
    puts "#{download_count} downloads today"
    puts "#{most_downloads.try(:rep).try(:official_full)}'s #{most_downloads.try(:city)} "\
      'office was the most downloaded office.'
    puts "#{request_count} requests today"
    puts "#{most_requests.try(:state).try(:name)}'s district #{most_requests.try(:code)} was the "\
      'most requested district today.'
  end

  def impression_sorter(column)
    lambda do
      unless column.blank?
        column.group(:impressionable_id).count.sort { |a, b| b[-1] <=> a[-1] }[0][0]
      end
    end
  end
end
