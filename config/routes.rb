# frozen_string_literal: true

Rails.application.routes.draw do
  # allows access to the API via http://herokuapp.com/api/any_endpoint
  # namespace :api, defaults: { format: :json }, path: '/api' do
  namespace :api do
    namespace :v1 do # version 1
      resources :zctas,            only: %i[index show]
      resources :reps,             only: %i[index show]
      resources :issues,           only: %i[index new create update]
      resources :office_locations, only: %i[index show]
      resources :districts,        only: %i[index show]
      resources :states,           only: %i[index show]
      resources :v_cards,          only: [:show]
    end

    namespace :beta do # beta version
      get '/reps/ids', to: 'reps#official_ids'
      resources :zctas,            only: %i[index show]
      resources :reps,             only: %i[index show]
      resources :issues,           only: %i[index new create update]
      resources :office_locations, only: %i[index show]
      resources :districts,        only: %i[index show]
      resources :states,           only: %i[index show]
      resources :v_cards,          only: [:show]
    end
  end

  # get '/reps', to: 'reps#index'
  # get '/reps/:id', to: 'reps#show'
  resources :zctas,            only: %i[index show]
  resources :reps,             only: %i[index show]
  resources :issues,           only: %i[index new create update]
  resources :office_locations, only: %i[index show]
  resources :districts,        only: %i[index show]
  resources :states,           only: %i[index show]
  resources :v_cards,          only: [:show]
  # get '/v_cards/:id', to: 'v_cards#show'
  get '/', to: 'reps#index', as: 'root'

  # OSDI STUFF!
  get '/osdi/people' => 'osdi_reps#index'
  get '/osdi/people/:id' => 'osdi_reps#show'
  get '/osdi' => 'osdi_reps#aep'
end
