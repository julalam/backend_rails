class AddNewFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :password, :string
    add_column :users, :country, :string
    add_column :users, :email, :string
  end
end
