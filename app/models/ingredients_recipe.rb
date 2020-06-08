class IngredientsRecipe < ApplicationRecord

  belongs_to :ingredient
  belongs_to :recipe

  validates :servings, presence: true

end
