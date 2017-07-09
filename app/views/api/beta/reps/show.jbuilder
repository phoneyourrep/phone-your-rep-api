# frozen_string_literal: true

rendering = JsonRendering.new json, route_prefix: :api_beta

rendering.response :rep, @rep
