FactoryBot.define do
  factory :recipe do
    user_id { "" }
    title { "MyString" }
    short_description { "MyString" }
    servings { 1.5 }
    cook_time_in_minutes { "" }
    prep_time_in_minutes { "" }
    directions { "MyText" }
    private { false }
  end
end
