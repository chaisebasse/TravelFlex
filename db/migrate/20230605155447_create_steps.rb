class CreateSteps < ActiveRecord::Migration[7.0]
  def change
    create_table :steps do |t|
      t.references :travel, null: false, foreign_key: true
      t.integer :num_step

      t.timestamps
    end
  end
end
