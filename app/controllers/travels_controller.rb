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


  # def create
  #   @travel = Travel.new(travel_params)
  #   @travel.user = current_user
  #   if @travel.save
  #     generate_map_image(@travel)
  #     redirect_to travel_path(@travel)
  #   else
  #     render :new
  #   end
  # end

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
    destination_region = params['region']
    destination_photo = params['photo_url']
    prompt_completion = "I am giving you a destination, a length of stay, a season.
    Build me a coherent trip with 2 activities per day,takes into account the round trip from Paris, and present those results in JSON that can be parsed in ruby
    (all the keys and values should be in double quotes).
    Each hash composing this array should be presented as followed :
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

    The locations should be coherent in terms of distance regarding the duration of the stay (limit the distances),
     take into account the travels beetwen activities.
    Give you responses in French."

    client = OpenAI::Client.new
    response = client.completions(
      parameters: {
        model: "text-davinci-003",
        prompt: prompt_completion,
        max_tokens: 3800
      })

    destinations = response['choices'][0]['text']
    destinations_array = JSON.parse(destinations)
    travel = Travel.create(destination: destination_choice,
    presentation_img_url: destination_photo,
    theme: destination_region,
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
    generate_map_image(travel)
    ScrapingDestination.where(user: current_user).destroy_all

    redirect_to travel_path(travel)
  end

  def generate_map_image(travel)
    markers = travel.activities.map do |activity|
      [activity.long.to_f, activity.lat.to_f]
    end

    mapbox_api_key = ENV['MAPBOX_API_KEY']
    size = "500x300"
    geojson = { type: "MultiPoint", coordinates: markers }.to_json
    points = CGI.escape(geojson)
    map_image_url = "https://api.mapbox.com/styles/v1/mapbox/streets-v12/static/geojson(#{points})/auto/#{size}?access_token=#{mapbox_api_key}"

    travel.update(travel_img_url: map_image_url)
  end

  def pdf
    @travel = Travel.find(params[:id])
    generate_map_image(@travel)
    respond_to do |format|
      format.pdf do
        pdf = render_to_string pdf: 'dashboard',
                               template: 'pages/travel',
                               encoding: 'UTF-8',
                               scss: 'pdf'
        send_data pdf, filename: 'votre_voyage.pdf', type: 'application/pdf', disposition: 'attachment'
      end
    end
  end

  private

  def set_travel
    @travel = Travel.find(params[:id])
  end

  def travel_params
    params.require(:travel).permit(:theme, :duration, :budget, :travelers, :starting_date, :travel_img_url )
  end
end
