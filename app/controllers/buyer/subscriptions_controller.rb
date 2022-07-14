# frozen_string_literal: true

class Buyer::SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[show_usage, increase_usage]
  include BuyerSubscription
  require 'date'
  layout 'buyer'
  def new
    @subscription = Subscription.new
  end

  def index
    @buyer_plans = current_user.plans
  end

  def create
      @subscription = Subscription.new(subscription_params.merge!(billing_day: Time.zone.today, buyer_id: current_user.id))
      @stripe_subscrption = StripeSubscription.new(stripe_subscription_params.merge!(user_id: current_user.id, stripe_plan_id: BuyerSubscription.stripe_plan_id(params[:subscription][:plan_id]), active: true))
      ActiveRecord::Base.transaction do
        response = @stripe_subscrption.save
        @subscription.save
        create_usage()
        flash[:success] = 'Plan subscribed successfully.'
        redirect_to buyer_subscriptions_path
        rescue => e
          flash[:error] = e.error.message
          render :new
      end
  end

  def show_usage
    @subscription = Subscription.find_by(plan_id: params[:id], buyer_id: current_user.id)
    respond_to do |format|
      format.js
    end
  end

  def increase_usage
  end

  def destroy
    @subscription = Subscription.find_by(buyer_id: current_user.id, plan_id: params[:id])
    @subscription.destroy

    respond_to do |format|
      format.html { redirect_to buyer_subscriptions_url, notice: 'Plan was unsubscribed successfully.' }
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:buyer_id, :billing_day, :plan_id)
  end

  def stripe_subscription_params
    params.permit(:card_number, :cvc, :exp_month, :exp_year)
  end

  def usage_params
    params.permit(:subscription_id, feature_id: [])
  end

  def create_usage
    subscription_data = BuyerSubscription.subscription_features_usage(params[:subscription][:plan_id], current_user.id)
    insert_features_usage(subscription_data)
  end
end
