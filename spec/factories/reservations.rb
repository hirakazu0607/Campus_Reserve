FactoryBot.define do
  factory :reservation do
    association :user
    association :facility
    start_time { 1.day.from_now.change(hour: 10, min: 0) }
    end_time { 1.day.from_now.change(hour: 12, min: 0) }
    status { :pending }
    purpose { "Team meeting and practice session" }

    trait :approved do
      status { :approved }
    end

    trait :rejected do
      status { :rejected }
    end

    trait :cancelled do
      status { :cancelled }
    end

    trait :tomorrow_afternoon do
      start_time { 1.day.from_now.change(hour: 14, min: 0) }
      end_time { 1.day.from_now.change(hour: 16, min: 0) }
    end

    trait :next_week do
      start_time { 7.days.from_now.change(hour: 10, min: 0) }
      end_time { 7.days.from_now.change(hour: 12, min: 0) }
    end
  end
end
