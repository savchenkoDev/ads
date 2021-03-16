FactoryBot.define do
  factory :ad do
    title { 'Ad title' }
    description { 'Ad description' }
    city { 'City' }
    user_id { 101 }
  end
end
