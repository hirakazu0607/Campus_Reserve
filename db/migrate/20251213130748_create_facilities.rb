class CreateFacilities < ActiveRecord::Migration[8.1]
  def change
    create_table :facilities do |t|
      t.string :name
      t.text :description
      t.integer :capacity
      t.boolean :available

      t.timestamps
    end
  end
end
