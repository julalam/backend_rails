class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.string :text
      t.integer :from
      t.integer :to
      t.string :language
      t.string :message
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
