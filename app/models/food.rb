class Food < ApplicationRecord
  belongs_to :user

  def self.create_food(user_id)
    5.times do
      Food.create!(name: Faker::Food.allergen, user_id:, rate: rand(1..5))
    end
  end
end
