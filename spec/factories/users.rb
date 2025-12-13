# spec/factories/users.rb
# FactoryBotでテスト用のUserデータを簡単に作成できるようにする

FactoryBot.define do
  factory :user do
    # 名前
    sequence(:name) { |n| "テストユーザー#{n}" }

    # 学籍番号・社員番号（重複しないようにsequenceを使用）
    sequence(:student_or_staff_number) { |n| 100000 + n } # 100001, 100002, 100003...

    # メールアドレス（重複しないようにsequenceを使用）
    sequence(:email) { |n| "user#{n}@example.com" }

    # パスワード
    password { "password123" }
    password_confirmation { "password123" }

    # デフォルトは学生
    role { :student }

    # 教職員バージョン
    trait :staff do
      sequence(:student_or_staff_number) { |n| 200000 + n } # 教職員は200001から
      role { :staff }
    end
  end
end
