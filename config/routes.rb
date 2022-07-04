Rails.application.routes.draw do


  namespace :admin do
    resources :featrues
    resources :plans
  end

  scope :admin, as: "admin" do
    root 'admin/featrues#index'
  end

  scope :buyer, as: "buyer" do
    root 'buyer/plans#index'
  end

  namespace :buyer do
    resources :subscriptions
  end

  devise_for :users

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  root :to => 'admin/featrues#index'
end
