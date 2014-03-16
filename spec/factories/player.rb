FactoryGirl.define do
  factory :player do
    birth_year { rand(1900..1995) }
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
  end
end
