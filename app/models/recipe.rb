class Recipe < ApplicationRecord

  has_many :ingredients_recipes
  has_many :ingredients, through: :ingredients_recipes
  has_many :tags, through: :ingredients_tags
  belongs_to :user

  validates :title, presence: true, uniqueness: true
  validates :directions, :servings, presence: true

  accepts_nested_attributes_for :ingredients, :tags

  attr_accessor :servings_change

  def nutrients_count
    nutrient_data = {}
    ingredients_recipes.each do |ingredient_recipe|
      ingredient_recipe.ingredient.ingredients_nutrients do |ingredient_nutrient|

      end
    end

  end

end
