FactoryBot.define do
  factory :question do
    query { "MyString" }
    day { "2021-11-22" }
    answer { "MyString" }
  end
end
