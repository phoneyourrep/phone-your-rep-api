# frozen_string_literal: true

require 'test_helper'

class RepsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rep  = Rep.create
    @user = User.create!(email:                 Faker::Internet.unique.email,
                         password:              'progressive_coders',
                         password_confirmation: 'progressive_coders')
  end

  test 'should get index' do
    get reps_url, as: :json
    assert_response :success
  end

  test 'valid user can create rep' do
    assert_difference('Rep.count') do
      post reps_url, params: {
        rep: { twitter: '@BernieSanders' }
      }, as: :json, headers: {
        'X-User-Email' => @user.email,
        'X-User-Token' => @user.authentication_token
      }
    end

    assert_response 201
  end

  test 'unauthed request cannot create rep' do
    post reps_url, params: { rep: {} }, as: :json

    assert_response 401
  end

  test 'should show rep' do
    get rep_url(@rep), as: :json
    assert_response :success
  end

  test 'should update rep' do
    patch rep_url(@rep), params: {
      rep: { twitter: '@SenSanders' }
    }, as: :json, headers: {
      'X-User-Email' => @user.email,
      'X-User-Token' => @user.authentication_token
    }

    assert_response 200
  end

  test 'should destroy rep' do
    assert_difference('Rep.count', -1) do
      delete rep_url(@rep), as: :json, headers: {
        'X-User-Email' => @user.email,
        'X-User-Token' => @user.authentication_token
      }
    end

    assert_response 204
  end
end
