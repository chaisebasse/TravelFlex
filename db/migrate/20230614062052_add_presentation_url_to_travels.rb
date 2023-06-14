class AddPresentationUrlToTravels < ActiveRecord::Migration[7.0]

  def change
    add_column :travels, :presentation_img_url, :string
  end
end
