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
    @travel = Travel.find(params[:id])
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
    destination_choice = params['destination']
    destination_region =  params['region']
    prompt_completion = "I am giving you a destination, a length of stay, a season. Can you find me two activities per day for this travel and present those result in JSON that can be parsed in ruby (all the keys and values should be in double quotes). Each hash composing this array should be presented as followed :
    {
    day: ,
    activity: ,
    description: ,
    location: ,
    latitude: ,
    longitude: ,
    transportation if needed:
    }
    Destination : #{destination_choice}
    Region: #{destination_region}
    Length of stay :  #{session[:query]["travel"]["duration"]}
    Season: #{session[:query]["travel"]["season"]}
    The activities location should be coherent in terms of distance regarding the duration of the stay (limit the distances).Takes into account travel times and coherence to return to France on the last day. Give you responses in French."

    client = OpenAI::Client.new
    response = client.completions(
      parameters: {
        model: "text-davinci-003",
        prompt: prompt_completion,
        max_tokens: 2000
      })

    destinations = response['choices'][0]['text']
    destinations_array = JSON.parse(destinations)
    travel = Travel.create(destination: destination_choice,
      travel_img_url: session[:query]["travel"]["travel_img_url"],
      theme: session[:query]["travel"]["theme"],
      title: "" ,
      duration: session[:query]["travel"]["duration"] ,
      budget: session[:query]["travel"]["budget"],
      travelers:session[:query]["travel"]["type_of_travelers"],
      user: current_user)

    destinations_array.each do |day|
      unless Step.find_by(travel: travel, num_step: day["day"])
        day_step = Step.new(num_step: day["day"])
        day_step.travel = travel
        day_step.save
      end
      activitie = Activity.new(title: day["activity"], status: "Pending", long: day["longitude"] , lat: day["latitude"] , jour: day["day"] ,localisation: day["location"], moyen_de_transport: day["transportation"], description: day["description"] )
      activitie.step = day_step
      activitie.save
    end
    # @markers = travel.activities.map do |activity|
    #   {
    #     lat: activity.lat.to_f,
    #     lng: activity.long.to_f
    #   }
    # end
    redirect_to travel_path(travel)
  end

  def pdf
    @travel = Travel.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = render_to_string pdf: 'dashboard', template: 'pages/travel', encoding: 'UTF-8'
        send_data pdf, filename: 'votre_voyage.pdf', type: 'application/pdf', disposition: 'attachment'
      end
    end
  end

  private

  def set_travel
    @travel = Travel.find(params[:id])
  end

  def travel_params
    params.require(:travel).permit(:theme, :duration, :budget, :travelers, :starting_date)
  end
end
