class ChangeDurationToBeAStringInTravels < ActiveRecord::Migration[7.0]
  def change
    change_column :travels, :duration, :string
  end
end
