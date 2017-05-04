# frozen_string_literal: true

class Avatar < ApplicationRecord
  belongs_to :rep

  def fetch_data(photo_url)
    update data: open(photo_url, &:read)
  rescue OpenURI::HTTPError => e
    logger.error e
  end
end
