class Nutrient < ApplicationRecord

  has_many :ingredients_nutrients
  has_many :ingredients, through: :ingredients_nutrients

end
