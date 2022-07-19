class Admin::PlansController < ApplicationController
  require 'stripe'
  include PlansUtilityModule
  layout 'admin'
  before_action :set_plan, only: %i[show edit update destroy]
  before_action :authenticate_user!

  def index
    @pagy, @plans = pagy(Plan.all, items: 5)
    authorize @plans
  end

  def show
    authorize @plan
    respond_to do |format|
      format.js
    end
  end

  def new
    @plan = Plan.new
    authorize @plan
  end

  def create
    if params[:plan][:feature_ids].length == 1
      flash[:error] = 'Please select at least one feature'
      redirect_to new_admin_plan_path
    else
      charges = PlansUtilityModule.calculate_monthly_charges(params[:plan][:feature_ids])
      @plan = Plan.new(plan_params.merge!(monthly_fee: charges))
      authorize @plan
      @stripe_plan = StripePlan.new(stripe_plan_params.merge!(name: params[:plan][:name], price_cents: charges*100))

      respond_to do |format|
        if @plan.save
          @stripe_plan.save
          format.html { redirect_to admin_plans_url notice: 'Plan was successfully created.' }
        else
          format.html { render :new }
        end
      end
    end
  end

  def destroy
    authorize @plan
    StripePlan.find_by(name: @plan.name).destroy
    @plan.destroy

    respond_to do |format|
      format.html { redirect_to admin_plans_url, notice: 'Plan was successfully deleted.' }
    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:name, :monthly_fee, feature_ids: [])
  end

  def stripe_plan_params
    params.permit(:name, :price_cents)
  end
end

