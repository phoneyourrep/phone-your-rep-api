# frozen_string_literal: true

require 'multi_json'
MultiJson.use :yajl
MultiJson.dump_options = { pretty: true }
