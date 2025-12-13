class AddNotNullConstraintsToUsers < ActiveRecord::Migration[8.1]
  def change
    change_column_null :users, :email, false
    change_column_null :users, :password_digest, false
    change_column_null :users, :role, false, 0  # デフォルト値: 0 (student)
    change_column_null :users, :student_or_staff_number, false

    # インデックスも追加（パフォーマンス向上）
    add_index :users, :student_or_staff_number, unique: true
  end
end
