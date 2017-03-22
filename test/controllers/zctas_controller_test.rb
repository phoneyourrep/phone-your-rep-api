# frozen_string_literal: true
require 'test_helper'

class ZctasControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get zctas_show_url
    assert_response :success
  end
end
