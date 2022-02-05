FactoryBot.define do
  factory :payment do
    price               { Faker::Number.between(from: 1, to: 999_999) }
    registration_date   { Faker::Date.backward }
    category_id         { Faker::Number.between(from: 2, to: 3) } # 現状カテゴリーは二つのため。拡張させていく場合は変更の必要あり。
    memo                { Faker::Lorem.sentence }

    association :user
  end
end
