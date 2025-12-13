class CreateReservations < ActiveRecord::Migration[8.1]
  def change
    create_table :reservations do |t|
      t.references :facility, null: false, foreign_key: true
      t.string :user_name
      t.string :user_email
      t.datetime :start_time
      t.datetime :end_time
      t.text :purpose
      t.string :status

      t.timestamps
    end
  end
end
