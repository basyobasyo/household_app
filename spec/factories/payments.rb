FactoryBot.define do
  factory :payment do
    price               { Faker::Number.between(from: 1, to: 999_999) }
    registration_date   { Faker::Date.backward }
    category_id         { Faker::Number.between(from: 2, to: 10) }
    memo                { Faker::Lorem.sentence }

    association :user
  end
end
