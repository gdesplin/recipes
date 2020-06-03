class IngredientsNutrient < ApplicationRecord

  belongs_to :ingredient
  belongs_to :nutrient

end
