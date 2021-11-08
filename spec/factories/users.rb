FactoryBot.define do
  factory :user do
    name { "abcdef" }
    email { "abcdef@example.com" }
    password_digest { "password" }
  end
end
