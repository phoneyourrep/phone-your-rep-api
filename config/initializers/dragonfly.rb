# frozen_string_literal: true

require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret '33aea43cd89b2ea879999b5d039d06b94045669272fbe009d7ff0360c7ac0875'

  url_format '/media/:job/:name'

  datastore :file,
            root_path: Rails.root.join('public/system/dragonfly', Rails.env),
            server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware if Rails.env.development?

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
