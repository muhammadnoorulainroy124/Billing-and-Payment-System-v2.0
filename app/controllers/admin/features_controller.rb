# frozen_string_literal: true

# Features Controller
class Admin::FeaturesController < ApplicationController
  layout 'admin'
  before_action :set_feature, only: %i[show edit update destroy]
  before_action :authenticate_user!

  def index
    @pagy, @features = pagy(Feature.all, items: 5)
    authorize @features
  end

  def show
    authorize @feature
    respond_to do |format|
      format.js
    end
  end

  def new
    @feature = Feature.new
    authorize @feature
  end

  def edit
    authorize @feature
  end

  def create
    @feature = Feature.new(feature_params)
    authorize @feature
    respond_to do |format|
      if @feature.save
        format.html { redirect_to admin_features_url, notice: 'Feature was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    authorize @feature
    respond_to do |format|
      if @feature.update(feature_params)
        format.html { redirect_to admin_features_url, notice: 'Feature was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authorize @feature
    @feature.destroy

    respond_to do |format|
      format.html { redirect_to admin_features_url, notice: 'Feature was successfully destroyed.' }
    end
  end

  private

  def set_feature
    @feature = Feature.find(params[:id])
  end

  def feature_params
    params.require(:feature).permit(:name, :code, :unit_price, :max_unit_limit)
  end
end
