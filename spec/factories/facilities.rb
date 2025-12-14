FactoryBot.define do
  factory :facility do
    sequence(:name) { |n| "施設#{n}" }
    description { "テスト用の施設です" }
    capacity { 50 }
    location { "1号館 101教室" }
  end
end
