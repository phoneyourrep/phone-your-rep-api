# frozen_string_literal: true

namespace :pyr do
  desc 'Summarize the day\'s activity'
  task :summary do
    downloads = Impression.where impressionable_type: 'OfficeLocation',
                                 created_at: (Time.now - 24.hours)..Time.now
    download_count = downloads.count
    queries = Impression.where impressionable_type: 'District',
                               created_at: (Time.now - 24.hours)..Time.now
    query_count = queries.count

    most_downloaded_id = lambda do
      unless downloads.blank?
        downloads.group(:impressionable_id).count.sort { |a, b| b[-1] <=> a[-1] }[0][0]
      end
    end
    most_downloads = OfficeLocation.find_by id: most_downloaded_id.call
    most_queried_id = lambda do
      unless queries.blank?
        queries.group(:impressionable_id).count.sort { |a, b| b[-1] <=> a[-1] }[0][0]
      end
    end
    most_queries = District.find_by id: most_queried_id.call
    puts "#{download_count} downloads today"
    puts "#{most_downloads.try(:rep).try(:official_full)}'s #{most_downloads.try(:city)} "\
      'office was the most downloaded office.'
    puts "#{query_count} queries today"
    puts "#{most_queries.try(:state)}'s district #{most_queries.try(:code)} was the "\
      'most queried district today.'
  end
end
