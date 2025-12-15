class AddNullConstraintsToFacilities < ActiveRecord::Migration[8.1]
  def change
    change_column_null :facilities, :name, false
    change_column_null :facilities, :capacity, false
    change_column_null :facilities, :location, false
  end
end
