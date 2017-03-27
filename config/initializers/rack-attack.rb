# frozen_string_literal: true
class Rack::Attack
  throttle('req/ip', limit: 5, period: 1.minute, &:ip)
end