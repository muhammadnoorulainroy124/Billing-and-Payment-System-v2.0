class Buyer::PlansController < ApplicationController
  layout 'buyer'
  include BuyerSubscription
  def new
    @subscription = Subscription.new
  end

  def def create
    if BuyerSubscription.insert_in_subscription_table(params[:subscription][:plan_id])
      flash[:success] = "Subscription successfully created"
      redirect_to :new_buyer_plan_path
    else
      flash[:error] = "Something went wrong"
      redirect_to :new_buyer_plan_path
    end
  end

    # @subscription = Subscription.new(subscription_params)
    # if @subscription.save
    #   flash[:success] = "Subscription successfully created"
    #   redirect_to :new_buyer_plan_path
    # else
    #   flash[:error] = "Something went wrong"
    #   render 'new'
    # end
  #end

  private
  def subscription_params
    params.permit(:subscription).permit(:billing_day, plan_ids:[])
  end

end
