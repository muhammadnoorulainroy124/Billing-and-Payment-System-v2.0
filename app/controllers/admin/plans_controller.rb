# frozen_string_literal: true

class Admin::PlansController < ApplicationController
  require 'stripe'
  include PlansUtilityModule
  layout 'admin'
  before_action :set_plan, only: %i[show edit update destroy]

  def index
    @plans = Plan.all
  end

  def show; end

  def new
    @plan = Plan.new
  end

  def edit; end

  def create
    charges = PlansUtilityModule.calculate_monthly_charges(params[:plan][:feature_ids])
    @plan = Plan.new(plan_params.merge!(monthly_fee: charges))
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

  def update
    respond_to do |format|
      if @plan.update(plan_params)
        format.html { redirect_to admin_plan_url(@plan), notice: 'Plan was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @plan.destroy

    respond_to do |format|
      format.html { redirect_to admin_plans_url, notice: 'Plan was successfully destroyed.' }
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

