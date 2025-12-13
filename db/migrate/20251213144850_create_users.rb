class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.integer :name, null: false # 学籍番号・社員番号（必須）
      t.string :email, null: false # メールアドレス（必須）
      t.string :password_digest, null: false # パスワード（必須）
      t.integer :role, default: 0, null: false # ロール（デフォルトは学生）

      t.timestamps
    end

    # インデックスを追加（検索速度向上＆一意性保証）
    add_index :users, :name, unique: true # 学籍番号は一意
    add_index :users, :email, unique: true # メールアドレスは一意
  end
end
