class ChangeColumnInUser < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :User_name, :username
  end
end
