# frozen_string_literal: true

class Buyer::SubscriptionsController < ApplicationController
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
        flash[:success] = 'Plan subscribed successfully.'
        redirect_to buyer_subscriptions_path

        rescue => e
          flash[:error] = e.error.message
          render :new
      end
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
end
