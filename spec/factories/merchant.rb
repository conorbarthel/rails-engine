FactoryBot.define do
  factory :book do
    title { Faker::Book.name }
  end
end
