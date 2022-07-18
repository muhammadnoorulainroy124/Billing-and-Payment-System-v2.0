# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :features
    resources :plans
    resources :transactions, only:[:index, :destroy] do
    end
  end

  scope :admin, as: 'admin' do
    root 'admin/features#index'
  end

  scope :buyer, as: 'buyer' do
    root 'buyer/subscriptions#index'
  end

  namespace :buyer do
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
end
