class ActivitiesController < ApplicationController
  def update
    @activity = Activity.find_by(params[:id])
    @activity.update(restaurant_params)
    redirect_to activity_path(@activity)
  end

  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy
    # No need for app/views/restaurants/destroy.html.erb
    redirect_to activity_path, status: :see_other
  end

  private

  def activity_params
    params.require(:activity).permit(:title, :long, :lat, :status, :activity_img_url)
  end
end
