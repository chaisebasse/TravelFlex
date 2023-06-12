class Step < ApplicationRecord
  belongs_to :travel
  has_many :activities, dependent: :destroy
end
