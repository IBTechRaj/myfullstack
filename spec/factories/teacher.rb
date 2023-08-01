FactoryBot.define do
    factory :teacher do
      first_name { 'John' }
      last_name  { 'Doe' }
      email { Faker::Internet.email }
      password {'A01@pass'}
    end
  end 