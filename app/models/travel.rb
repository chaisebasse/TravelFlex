class Travel < ApplicationRecord
  belongs_to :user
  has_many :steps, dependent: :destroy
  has_many :activities, through: :steps

  validates :budget, presence: true

  attr_accessor :season
  attr_accessor :type

  def step_coordinates
    self.steps.flat_map(&:activities).map { |activity| [activity.long, activity.lat] }
  end

<<<<<<< HEAD
  def grouped_activities
    activities.group_by { |act| act.jour }
=======
  def parsed_description
    parsing_json = JSON.parse(self.description).find { |_, value| value['pays'].downcase == self.destination.downcase }
    parsing_json.second["text_content"].join
>>>>>>> master
  end
end
