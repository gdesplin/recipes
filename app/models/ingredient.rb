class Ingredient < ApplicationRecord

  has_many :recipes, through: :ingredients_recipes
  has_many :nutrients, through: :ingredients_nutrients

  validates :name, presence: true
  validates :food_data_central_id, presence: true, uniqueness: true

  accepts_nested_attributes_for :nutrients

end
