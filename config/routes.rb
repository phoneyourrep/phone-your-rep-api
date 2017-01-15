# frozen_string_literal: true
Rails.application.routes.draw do
  # allows access to the API via http://herokuapp.com/api/any_endpoint
  # namespace :api, defaults: { format: :json }, path: '/api' do

  get '/osdi/people' => 'reps2#index'
  get '/osdi/people/:id' => 'reps2#show'
  get '/osdi' => 'reps2#aep'

  resources :reps
  resources :issues, only: [:index, :new, :create]
  get '/v_cards/:id',  to: 'v_cards#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
