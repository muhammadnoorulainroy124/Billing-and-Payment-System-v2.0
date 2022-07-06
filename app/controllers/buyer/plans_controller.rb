# frozen_string_literal: true

class Buyer::PlansController < ApplicationController
  layout 'buyer'
  include BuyerSubscription
  def new
    @subscription = Subscription.new
  end

  def def(_create)
    if BuyerSubscription.insert_in_subscription_table(params[:subscription][:plan_id])
      flash[:success] = 'Subscription successfully created'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to :new_buyer_plan_path
  end

  private

  def subscription_params
    params.permit(:subscription).permit(:billing_day, plan_ids: [])
  end
end
