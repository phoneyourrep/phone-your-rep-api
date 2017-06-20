# frozen_string_literal: true

require 'governor_scraper/page_scraper'

class GovernorScraper
  class Panel < PageScraper
    def image
      @_image ||= raw.css('.governors-img img').first['src']
    end

    def bio_page
      @_bio_page ||= raw.css('.governors-state a').first['href']
    end

    def governor_name
      @_governor_name ||= raw.css('.governors-state a').
          first.
          text.
          sub('Governor ', '').
          gsub('  ', ' ')
    end

    def state
      @_state ||= raw.css('.governors-state h3').first.text
    end
  end
end