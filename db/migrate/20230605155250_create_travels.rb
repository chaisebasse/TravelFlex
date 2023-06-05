class CreateTravels < ActiveRecord::Migration[7.0]
  def change
    create_table :travels do |t|
      t.references :user, null: false, foreign_key: true
      t.string :destination
      t.string :travel_img_url
      t.string :theme
      t.string :title
      t.integer :duration
      t.integer :budget
      t.integer :travelers
      t.date :starting_date

      t.timestamps
    end
  end
end
