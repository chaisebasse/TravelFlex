class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @travels = Travel.all
  end

  def dashboard
    if user_signed_in?
      @travels = current_user.travels
      @travels = current_user.travels
    else
      redirect_to new_user_session_path
    end
  end

  
end
