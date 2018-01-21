class AddLanguageId < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :language_id, :integer
    remove_column :users, :language, :string

    add_column :messages, :language_id, :integer
    remove_column :messages, :language, :string
  end
end
