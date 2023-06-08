class AddColumnsToActivity < ActiveRecord::Migration[7.0]
  def change
      add_column :activities, :jour, :string
      add_column :activities, :localisation, :string
    end
end
