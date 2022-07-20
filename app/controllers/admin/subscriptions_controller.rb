class Admin::SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def index
   @pagy, @subscriptions = pagy(Subscription.all, items: 1)
  end

end
