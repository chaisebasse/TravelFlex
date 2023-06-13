class Travel < ApplicationRecord
  belongs_to :user
  has_many :steps, dependent: :destroy
  has_many :activities, through: :steps

  validates :budget, presence: true

  attr_accessor :season
  attr_accessor :type
end
