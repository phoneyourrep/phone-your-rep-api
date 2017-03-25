# frozen_string_literal: true
Rails.application.routes.draw do
  # allows access to the API via http://herokuapp.com/api/any_endpoint
  # namespace :api, defaults: { format: :json }, path: '/api' do
  namespace :api do
    namespace :v1 do # version 1
      resources :zctas,            only: [:index, :show]
      resources :reps,             only: [:index, :show]
      resources :issues,           only: [:index, :new, :create, :update]
      resources :office_locations, only: [:index, :show]
      resources :districts,        only: [:index, :show]
      resources :states,           only: [:index, :show]
    end

    namespace :beta do # beta version
      resources :zctas,            only: [:index, :show]
      resources :reps,             only: [:index, :show]
      resources :issues,           only: [:index, :new, :create, :update]
      resources :office_locations, only: [:index, :show]
      resources :districts,        only: [:index, :show]
      resources :states,           only: [:index, :show]
    end
  end

  # get '/reps', to: 'reps#index'
  # get '/reps/:id', to: 'reps#show'
  resources :zctas,            only: [:index, :show]
  resources :reps,             only: [:index, :show]
  resources :issues,           only: [:index, :new, :create, :update]
  resources :office_locations, only: [:index, :show]
  resources :districts,        only: [:index, :show]
  resources :states,           only: [:index, :show]
  get '/v_cards/:id', to: 'v_cards#show'

  # OSDI STUFF!
  get '/osdi/people' => 'osdi_reps#index'
  get '/osdi/people/:id' => 'osdi_reps#show'
  get '/osdi' => 'osdi_reps#aep'
end
