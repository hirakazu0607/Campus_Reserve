class CreateReservations < ActiveRecord::Migration[8.1]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :facility, null: false, foreign_key: true, index: true
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.integer :status, null: false, default: 0
      t.text :purpose

      t.timestamps
    end
    add_index :reservations, [ :facility_id, :start_time, :end_time ]
    add_index :reservations, :status
  end
end
