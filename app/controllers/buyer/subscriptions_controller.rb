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
    if params[:subscription][:plan_id].length == 1
      flash[:error] = "Please select at least one plan!"
      redirect_to new_buyer_subscription_path
    else
      params[:subscription][:plan_id].each do |p_id|
        next if p_id == ""
        @subscription = Subscription.new(subscription_params.merge!(plan_id: p_id.to_i, billing_day: Date.today, buyer_id: current_user.id))
        @subscription.save
      end
      flash[:success] = "Plan(s) subscribed successfully."
      redirect_to buyer_subscriptions_path
    end

  end

  private
  def subscription_params
    params.require(:subscription).permit(:buyer_id, :billing_day, plan_id:[])
  end

end
