class TravelsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new]
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
    @travel = Travel.new(travel_params)
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


  def create_activity


  end

  def details
    client = OpenAI::Client.new
    response = client.completions(
      parameters: {
        model: "text-davinci-003",
        prompt: 'Construis un JSON voyage au #{params[:destination_choice]} par jour avec un itinéraire cohérent (pense au retour) depuis la France, si besoin #{params[:permis de conduire]},
          pour une durée de #{params[:duration]} jours en #{params[:saison]}, #{params[:nombre_activite]} activités par jour/
          [{"jour": "Activité + description":, "localisation":, "lat":, "long": "moyen de transport":}]',
        max_tokens: 2000
      })
    destinations = response['choices'][0]['text']
    destinations_array = JSON.parse(destinations)
    travel = Travel.create(destination: session[:query][:destination] ,travel_img_url: session[:query][:travel_img_url], theme: session[:query][:theme], title: "" , duration: session[:query][:duration] ,budget: session[:query][:duration],travelers:session[:query][:type_of_travelers])
    destinations_array.each do |day|
      unless Step.find_by(travel: travel, num_step: day["jour"])
        day_step = Step.new(num_step: day["jour"])
        day_step.travel = travel
        day_step.save
      end
      activitie = Activity.new(title: day["Activité"] , status: "Pending", long: day["lon"] , lat: day["lat"] , jour: day["jour"] ,localisation: day["localisation"], moyen_de_transport: day["moyen de transport"], description: day["Description"] )
      activitie.step = day_step
      activitie.save
    end
    redirect_to dashboard_path
  end

  private

  def set_travel
    @travel = Travel.find(params[:id])
  end

  def travel_params
    params.require(:travel).permit(:theme, :duration, :budget, :travelers, :starting_date)
  end
end
