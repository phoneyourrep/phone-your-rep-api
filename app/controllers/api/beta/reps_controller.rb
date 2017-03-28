# frozen_string_literal: true
module Api
  module Beta
    class RepsController < ::RepsController
      include Api::Beta
    end
  end
end
