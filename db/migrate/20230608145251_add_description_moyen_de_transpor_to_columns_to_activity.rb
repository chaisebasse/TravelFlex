class AddDescriptionMoyenDeTransporToColumnsToActivity < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :description, :string
    add_column :activities, :moyen_de_transport, :string
  end
end
