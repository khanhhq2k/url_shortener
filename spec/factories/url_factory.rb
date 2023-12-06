FactoryBot.define do
  factory :url do
    hash_value { Faker::Alphanumeric.alphanumeric(number: 6) }
    original_url  { Faker::Internet.url }
    expired_at { DateTime.now + 1.year }
  end
end