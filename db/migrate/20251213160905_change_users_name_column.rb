class ChangeUsersNameColumn < ActiveRecord::Migration[8.1]
  def change
    rename_column :users, :name, :student_or_staff_number
    add_column :users, :name, :string, null: false, default: ''
  end
end
