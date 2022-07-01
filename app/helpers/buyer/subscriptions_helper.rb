module Buyer::SubscriptionsHelper
  @@is_plan_available = false

  def get_not_subscribed_plans
    buyer_plans = current_user.plans
    not_subscribed = Plan.left_joins(:subscriptions).where.not(id: buyer_plans)
    if(not_subscribed).length > 0
      @@is_plan_available = true
    end
    return not_subscribed
  end

  def get_all_plans
    Plan.all
  end

  def get_all_features_of_plan(plan)
    features = plan.featrues
  end

  def is_available
    @@is_plan_available
  end

end
