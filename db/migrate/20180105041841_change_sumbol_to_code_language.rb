class ChangeSumbolToCodeLanguage < ActiveRecord::Migration[5.1]
  def change
    rename_column :languages, :symbol, :code
  end
end
