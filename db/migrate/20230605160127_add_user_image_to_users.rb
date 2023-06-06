class AddUserImageToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :user_img, :string
  end
end
