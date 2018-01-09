class AddForeignKey < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :contacts, :users, column: :from, primary_key: :id
    add_foreign_key :contacts, :users, column: :to, primary_key: :id
  end
end
