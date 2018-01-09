class AddNativeNameToLanguages < ActiveRecord::Migration[5.1]
  def change
    add_column :languages, :native_name, :string
  end
end
