# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :features
    resources :plans
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
        post 'increase_usage'
      end
    end
  end

  devise_for :users

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  mount StripeEvent::Engine, at: 'webhooks'

  root to: 'admin/features#index'
end
