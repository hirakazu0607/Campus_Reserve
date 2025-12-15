class CreateFacilities < ActiveRecord::Migration[8.1]
  def change
    create_table :facilities do |t|
      t.string :name, null: false
      t.text :description
      t.integer :capacity, null: false
      t.string :location, null: false

      t.timestamps
    end

    add_index :facilities, :name, unique: true
  end
end
