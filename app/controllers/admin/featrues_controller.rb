class Admin::FeatruesController < ApplicationController
  layout 'admin'
  before_action :set_featrue, only: %i[ show edit update destroy ]


  def index
    @featrues = Featrue.all
  end


  def show
    respond_to do |format|
      format.js
    end
  end


  def new
    @featrue = Featrue.new
  end


  def edit
  end


  def create
    @featrue = Featrue.new(featrue_params)

    respond_to do |format|
      if @featrue.save
        format.html { redirect_to admin_featrues_url, notice: "Featrue was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @featrue.update(featrue_params)
        format.html { redirect_to admin_featrues_url, notice: "Featrue was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @featrue.destroy

    respond_to do |format|
      format.html { redirect_to admin_featrues_url, notice: "Featrue was successfully destroyed." }
    end
  end

  private
    def set_featrue
      @featrue = Featrue.find(params[:id])
    end

    def featrue_params
      params.require(:featrue).permit(:name, :code, :unit_price, :usage, :max_unit_limit)
    end
end
