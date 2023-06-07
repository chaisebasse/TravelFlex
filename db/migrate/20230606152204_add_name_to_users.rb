class AddNameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :User_name, :string
  end
end
