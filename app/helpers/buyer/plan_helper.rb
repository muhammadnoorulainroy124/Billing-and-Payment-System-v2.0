module Buyer::PlanHelper
  def get_not_subscribed_plans
    buyer_plans = current_user.plans
    Plan.left_joins(:subscriptions).where.not(id: buyer_plans)
  end

  def get_all_plans
    Plan.all
  end

  def get_all_features_of_plan(plan)
    features = plan.featrues
  end
end
