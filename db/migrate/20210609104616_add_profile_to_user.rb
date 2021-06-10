class AddProfileToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :first_name, :text
    add_column :users, :last_name, :text
    add_column :users, :auth_token, :text
    add_index :users, :auth_token, unique: true
  end
end
