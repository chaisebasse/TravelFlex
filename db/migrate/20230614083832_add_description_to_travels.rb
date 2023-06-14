class AddDescriptionToTravels < ActiveRecord::Migration[7.0]

  def change
    add_column :travels, :description, :string
  end

end
