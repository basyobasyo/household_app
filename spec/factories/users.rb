FactoryBot.define do
  factory :user do
    nickname {Faker::Name.name}
    email {Faker::Internet.free_email}
    password { Faker::Alphanumeric.alphanumeric(number: 6, min_alpha: 1, min_numeric: 1) } # 英数字混在6文字
    password_confirmation {password}
  end
end