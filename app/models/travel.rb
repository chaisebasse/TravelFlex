class Travel < ApplicationRecord
  belongs_to :user
  has_many :steps, dependent: :destroy
  has_many :activities, through: :steps

  validates :budget, presence: true

<<<<<<< HEAD
  attr_accessor :season
  attr_accessor :type
=======
>>>>>>> 46823b15916665b68dbc33105b1e97d4817fbdd1
end
