class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.integer :from
      t.integer :to
      t.string :status, default: 'pending'

      t.timestamps
    end
  end
end
