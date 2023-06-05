class CreateActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :activities do |t|
      t.string :title
      t.string :status
      t.string :activity_img_url
      t.float :long
      t.float :lat
      t.references :step, null: false, foreign_key: true

      t.timestamps
    end
  end
end
