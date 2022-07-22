# frozen_string_literal: true

module BuyerUser
  class SubscriptionsController < ApplicationController
    before_action :set_subscription, on: %i[show_usage increase_usage destroy]
    require 'date'
    layout 'buyer'
    def new
      @subscription = Subscription.new
      authorize @subscription
    end

    def index
      @pagy, @buyer_plans = pagy(current_user.plans, items: 5)
    end

    def create
      @subscription = Subscription.new(subscription_params.merge!(billing_day: Time.zone.today, buyer_id: current_user.id))
      authorize @subscription
      @stripe_subscription = StripeSubscription.new(stripe_subscription_params.merge!(user_id: current_user.id, stripe_plan_id: @subscription.stripe_plan_id, active: true))
      perform_transaction(@subscription, @stripe_subscription)
    end

    def show_usage
      authorize @subscription
      respond_to do |format|
        format.js
      end
    end

    def increase_usage
      authorize @subscription
      @subscription.verify_usage_limit(params)
      @subscription.update_usage(params)
      flash[:success] = 'Usage has been updated successfully'
      redirect_to buyer_subscriptions_path
    end

    def destroy
      authorize @subscription
      @subscription.destroy

      respond_to do |format|
        format.html { redirect_to buyer_subscriptions_url, notice: 'Plan was unsubscribed successfully.' }
      end
    end

    def max_limit
      @feature_ids = params[:f_ids]
      respond_to do |format|
        format.js { render 'show_usage' }
      end
    end

    private

    def subscription_params
      params.require(:subscription).permit(:buyer_id, :billing_day, :plan_id)
    end

    def stripe_subscription_params
      params.permit(:card_number, :cvc, :exp_month, :exp_year)
    end

    def set_subscription
      @subscription = Subscription.find_by(plan_id: params[:id], buyer_id: current_user.id)
    end

    def perform_transaction(subscription, stripe_subscription)
      ActiveRecord::Base.transaction do
        stripe_subscription.save!
        subscription.save!
        flash[:success] = 'Plan subscribed successfully.'
        redirect_to buyer_subscriptions_path
      rescue StandardError => e
        flash[:error] = e.message
        render :new
      end
    end
  end
end
