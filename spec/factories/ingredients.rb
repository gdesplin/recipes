FactoryBot.define do
  factory :ingredient do
    name { "MyString" }
    measurement { "" }
    amount { 1.5 }
    food_data_central_id { "" }
    kcals { 1.5 }
    carbohydrates { 1.5 }
    proteins { 1.5 }
    fat { 1.5 }
    sugars_added { 1.5 }
    sugars_natural { 1.5 }
  end
end
