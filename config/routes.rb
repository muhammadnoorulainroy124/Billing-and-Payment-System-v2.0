# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin_user, as: 'admin' do
    resources :features
    resources :plans
    resources :transactions, only: %i[index destroy]
    resources :subscriptions, only: :index
  end

  scope :admin_user, as: 'admin' do
    root 'admin_user/features#index'
  end

  scope :buyer_user, as: 'buyer' do
    root 'buyer_user/subscriptions#index'
  end

  namespace :buyer_user, as: 'buyer' do
    resources :subscriptions do
      member do
        get 'show_usage'
        patch 'increase_usage'
      end
      collection do
        post 'max_limit'
      end
    end
  end

  devise_for :users

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    root to: 'devise/sessions#new'
  end

  mount StripeEvent::Engine, at: 'webhooks'

  get '*path' => redirect('/users/sign_in')
end
