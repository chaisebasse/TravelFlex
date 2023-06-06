class TravelsController < ApplicationController
  before_action :set_travel, only: %i[show edit update destroy]

  def index
    @travels = Travel.all
  end

  def new
    @travel = Travel.new
  end

  def show
  end

  def create
    @travel = Travel.new(params_travel)
    @travel.user = current_user
  end

  def edit
    redirect_to travel_path(@travel)
  end

  def update
  end

  def destroy
    @travel.destroy
    redirect_to dashboard_path
  end

  private

  def set_travel
    @travel = Travel.find(params[:id])
  end
end
