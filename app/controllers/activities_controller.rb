class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[update destroy]

  def update
    @activity.update(travel_params)
    redirect_to activity_path(@activity)
  end

  def destroy
    @activity.destroy
    redirect_to activity_path, status: :see_other
  end

  private

  def activity_params
    params.require(:activity).permit(:title, :long, :lat, :status, :activity_img_url)
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end
end
