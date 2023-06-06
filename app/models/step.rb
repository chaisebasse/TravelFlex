class Step < ApplicationRecord
  belongs_to :travel
  has_many :activities
end
